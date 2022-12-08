#!/usr/bin/env python

import re
import os

import xml2rfc
import lxml
from lxml.html import html_parser
from lxml.html.builder import ElementMaker

build = ElementMaker(makeelement=html_parser.makeelement)

class HtmlWriter:
    def __init__(self, xmlrfcEN, xmlrfcJA):
        self._rootEN = xmlrfcEN.getroot()
        self._rootJA = xmlrfcJA.getroot()

    def html_tree(self):
        html_tree = self.render(None, self.root)
        return html_tree

    def html(self, html_tree=None):
        if html_tree is None:
            html_tree = self.html_tree()
        html = lxml.etree.tostring(html_tree, method='html', encoding='unicode', pretty_print=True, doctype="<!DOCTYPE html>")
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

    def render1(self, h, x):
        res = None

        if x.tag in (lxml.etree.PI, lxml.etree.Comment):
            tail = x.tail if x.tail and x.tail.strip() else ''
            if len(h):
                last = h[-1]
                last.tail = (last.tail or '') + tail
            else:
                h.text = (h.text or '') + tail
        else:
            func_name = "render1_%s" % (x.tag.lower(),)
            func = getattr(self, func_name, None)
            if func == None:
                func = self.default_renderer1
            res = func(h, x)
        return res

    def default_renderer(self, h, en, ja):
        return h

    def render_rfc(self, h, en, ja):
        self.part = en.tag

        # Root Element
        html = h if h != None else build('html')
        self.html_root = html

        # <head> Element
        head = build('head')
        html.append(head)

        # CSS組み込み
        data_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'data')
        cssin = os.path.join(data_dir, 'xml2rfc-ja.css')
        with open(cssin, encoding='utf-8') as f:
            css = f.read()
        style = build('style', type="text/css")
        style.text = css
        head.append(style)

        # <body> Element
        body = build('body')
        html.append(body)

        data_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'data')

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

    def render_front(self, h, en, ja):
        return None # TODO

    def render_middle(self, h, en, ja):
        for (c0, c1) in zip(en, ja):
            self.render(h, c0, c1)
        return h

    def render_section(self, h, en, ja):
        section = build('section')
        h.append(section)
        for (c0, c1) in zip(en, ja):
            self.render(section, c0, c1)
        return section

    def render_name(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        self.lang = 'en'
        self.render1(parent, en)
        self.lang = 'ja'
        self.render1(parent, ja)
        return h

    def render_t(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        self.lang = 'en'
        self.render1(parent, en)
        self.lang = 'ja'
        self.render1(parent, ja)
        return h

    def render_back(self, h, ja, en):
        return None # TODO

    def default_renderer1(self, h, x):
        h.text = x.text
        return h

    def render1_name(self, h, x):
        p = x.getparent()
        if p.tag not in [ 'note', 'section', 'references' ]:
            return None
        name_slug = x.get('slugifiedName') or None
        if name_slug:
            name_slug += '-' + self.lang
        pn = p.get('pn')
        header = build('h1', id=name_slug, lang=self.lang)
        h.append(header)

        if name_slug:
            a_title = build('a', href='#%s'%name_slug)
        else:
            a_title = build('span')
        self.inline_text_renderer(a_title, x)
        header.append(a_title)
        return h

    def render1_t(self, h, x):
        p = build('p', lang=self.lang)
        h.append(p)

        if x.text:
            p.text = x.text
        for c in x:
            ret = self.render1(p, c)
            if c.text:
                ret.text = c.text
            if c.tail:
                ret.tail = c.tail
        return p

    def render1_xref(self, h, x):
        a = build('a')
        h.append(a)
        return a

    def inline_text_renderer(self, h, x):
        h.text = x.text.lstrip() if x.text else ''
        children = list(x)
        if children:
            for c in children:
                self.render(h, c)
            last = h[-1]
            last.tail = last.tail.rstrip() if last.tail else ''
        else:
            h.text = h.text.rstrip()
        h.tail = x.tail

def main():
    parserEN = xml2rfc.XmlRfcParser("src/en/rfc9226.xml")
    rfcEN = parserEN.parse()
    parserJA = xml2rfc.XmlRfcParser("src/ja/rfc9226.xml")
    rfcJA = parserJA.parse()

    writer = HtmlWriter(rfcEN, rfcJA)
    writer.write()

if __name__ == "__main__":
    main()
