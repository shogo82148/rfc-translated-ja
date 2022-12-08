#!/usr/bin/env python

import re

import xml2rfc
import lxml
from lxml.html import html_parser
from lxml.html.builder import ElementMaker
from xml2rfc.utils import namespaces, is_htmlblock, find_duplicate_html_ids, build_dataurl, sdict, clean_text
from xml2rfc.writers.base import default_options, BaseV3Writer, RfcWriterError

def wrap(h, tag, **kwargs):
    w = build(tag, **kwargs)
    w.append(h)
    return w

def id_for_pn(pn):
    """Convert a pn to an HTML element ID"""
    if HtmlWriter.is_appendix(pn):
        _, num, para = HtmlWriter.split_pn(pn)
        frag = 'appendix-%s' % num.title()
        if para is None or len(para) == 0:
            return frag
        else:
            return '%s-%s' % (frag, para)
    # not an appendix
    return pn

class ClassElementMaker(ElementMaker):

    def __call__(self, tag, *children, **attrib):
        classes = attrib.pop('classes', None)
        attrib = sdict(dict( (k,v) for k,v in attrib.items() if v != None))
        elem = super(ClassElementMaker, self).__call__(tag, *children, **attrib)
        if classes:
            elem.set('class', classes)
        if is_htmlblock(elem) and (elem.tail is None or elem.tail.strip() == ''):
            elem.tail = '\n'
        return elem
build = ClassElementMaker(makeelement=html_parser.makeelement)

class ExtendingElementMaker(ClassElementMaker):

    def __call__(self, tag, parent, precursor, *children, **attrib):
        elem = super(ExtendingElementMaker, self).__call__(tag, *children, **attrib)
        is_block = is_htmlblock(elem)
        #
        child = elem
        if precursor != None:
            pn = precursor.get('pn')
            sn = precursor.get('slugifiedName')
            an = precursor.get('anchor')
            if   pn != None:
                id = id_for_pn(pn)
                elem.set('id', id)
                if an != None:
                    if is_block:
                        child = wrap(elem, 'div', id=an)
                    else:
                        # cannot wrap a non-block in <div>, so we invert the
                        # wrapping by swapping the tags:
                        child = wrap(elem, 'div', id=id, **attrib)
                        elem.tag = child.tag
                        child.tag = tag
                        for k in attrib:
                            if k in elem.attrib:
                                del elem.attrib[k]
                        elem.set('id', an)
            elif sn != None:
                elem.set('id', sn)
            elif an != None:
                elem.set('id', an)
            kp = precursor.get('keepWithPrevious', '')
            if kp:
                elem.set('class', ' '.join(s for s in [elem.get('class', ''), 'keepWithPrevious'] if s ))
            kn = precursor.get('keepWithNext', '')
            if kn:
                elem.set('class', ' '.join(s for s in [elem.get('class', ''), 'keepWithNext'] if s ))
            if not elem.text or elem.text.strip() == '':
                elem.text = precursor.text
            elem.tail = precursor.tail
        if parent != None:
            parent.append(child)
        if is_block and (elem.tail is None or elem.tail.strip() == ''):
            elem.tail = '\n'
        if is_block and child != elem and (child.tail is None or child.tail.strip() == ''):
            child.tail = '\n'
        return elem
add  = ExtendingElementMaker(makeelement=html_parser.makeelement)

class HtmlWriter(BaseV3Writer):
    def __init__(self, xmlrfcEN, xmlrfcJA):
        super(HtmlWriter, self).__init__(xmlrfcEN)
        self._rootEN = xmlrfcEN.getroot()
        self._rootJA = xmlrfcJA.getroot()

    def html_tree(self):
        html_tree = self.render(None, self.root)
        return html_tree

    def html(self, html_tree=None):
        if html_tree is None:
            html_tree = self.html_tree()
        # 6.1.  DOCTYPE
        # 
        #    The DOCTYPE of the document is "html", which declares that the
        #    document is compliant with HTML5.  The document will start with
        #    exactly this string:
        # 
        #    <!DOCTYPE html>
        html = lxml.etree.tostring(html_tree, method='html', encoding='unicode', pretty_print=True, doctype="<!DOCTYPE html>")
        html = re.sub(r'[\x00-\x09\x0B-\x1F]+', ' ', html)
        return html

    def write(self):
        html_tree = self.render(None, self._rootEN, self._rootJA)
        with open("docs/rfc9226.html", 'w', encoding='utf-8') as file:
            text = self.html(html_tree)
            file.write(text)

    def render(self, h, en, ja):
        res = None
        if en.tag != ja.tag:
            raise NameError('tag name not match')

        if en.tag in (lxml.etree.PI, lxml.etree.Comment):
            tail = en.tail if en.tail and en.tail.strip() else ''
            if len(h):
                last = h[-1]
                last.tail = (last.tail or '') + tail
            else:
                h.text = (h.text or '') + tail
        else:
            func_name = "render_%s" % (en.tag.lower(),)
            func = getattr(self, func_name, None)
            if func == None:
                func = self.default_renderer
            res = func(h, en, ja)
        return res

    def default_renderer(self, h, en, ja):
        parent = add('div', h, None)
        add(en.tag, h, en)
        add(ja.tag, h, ja)
        for c in zip(en, ja):
            self.render(parent, c[0], c[1])
        return parent

    def render_rfc(self, h, en, ja):
        self.part = en.tag

        # Root Element
        html = h if h != None else build.html()
        self.html_root = html

        # <head> Element
        head = add.head(html, None)
        add.meta(head, None, charset='utf-8')
        add.meta(head, None, name="viewport", content="initial-scale=1.0")

        # <body> Element
        body = add.body(html, None, classes='xml2rfc')

        contents = zip(
            [ en.find('front'), en.find('middle'), en.find('back') ],
            [ ja.find('front'), ja.find('middle'), ja.find('back') ],
        )
        for (c1, c2) in contents:
            if c1 == None or c2 == None:
                continue
            self.part = c1.tag
            self.render(body, c1, c2)

        return html

def main():
    parserEN = xml2rfc.XmlRfcParser("src/en/rfc9226.xml")
    rfcEN = parserEN.parse()
    parserJA = xml2rfc.XmlRfcParser("src/ja/rfc9226.xml")
    rfcJA = parserJA.parse()

    writer = HtmlWriter(rfcEN, rfcJA)
    writer.write()

if __name__ == "__main__":
    main()
