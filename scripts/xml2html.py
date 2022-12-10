#!/usr/bin/env python

import re
import os

import sys
import xml2rfc
import lxml
from lxml.html import html_parser
from lxml.html.builder import ElementMaker

build = ElementMaker(makeelement=html_parser.makeelement)

class HtmlWriter:
    def __init__(self, xmlrfcEN, xmlrfcJA):
        self.root_en = xmlrfcEN.getroot()
        self.root_ja = xmlrfcJA.getroot()

    def html_tree(self):
        html_tree = self.render(None, self.root)
        return html_tree

    def html(self, html_tree=None):
        if html_tree is None:
            html_tree = self.html_tree()
        html = lxml.etree.tostring(html_tree, method='html', encoding='unicode', pretty_print=True, doctype="<!DOCTYPE html>")
        return html

    def write(self, rfc_number):
        html_tree = self.render(None, self.root_en, self.root_ja)
        with open("docs/rfc%s.html" % (rfc_number,), 'w', encoding='utf-8') as file:
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

        # 文字コードの指定
        head.append(build('meta', charset='utf-8'))
        head.append(build('meta', name='viewport', content='initial-scale=1.0'))

        # タイトル
        title = ja.find('./front/title')
        text = ' '.join(title.itertext())
        text = ("RFC %s: " % en.get('number')) + text + "（日本語訳）"
        title = build('title')
        title.text = text
        head.append(title)

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
        for (c0, c1) in zip(en, ja):
            self.render(h, c0, c1)
        return h

    def render_title(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')
        rfc_number = self.root_en.get('number')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        title_en = '\u2028'.join(en.itertext())
        h1_en = build('h1')
        h1_en.text = title_en
        div_en.append(h1_en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        title_ja = '\u2028'.join(ja.itertext())
        h1_ja = build('h1')
        h1_ja.text = title_ja
        div_ja.append(h1_ja)

    def render_abstract(self, h, en, ja):
        # 概要の見出しをレンダリング
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        h1_en = build('h1')
        h1_en.text = 'Abstract'
        div_en.append(h1_en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        h1_ja = build('h1')
        h1_ja.text = '概要'
        div_ja.append(h1_ja)

        # 概要本文
        abstract = build('section')
        h.append(abstract)
        for (c0, c1) in zip(en, ja):
            self.render(abstract, c0, c1)
        return abstract

    def render_middle(self, h, en, ja):
        for (c0, c1) in zip(en, ja):
            self.render(h, c0, c1)
        return h

    def render_boilerplate(self, h, en, ja):
        for (c0, c1) in zip(en, ja):
            self.render(h, c0, c1)
        return h

    def render_toc(self, h, en, ja):
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
        parent.set('class', 'row')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
        return h

    def render_t(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
        return h

    def render_table(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
        return h

    def render_ul(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')

        # 英語
        div_en = build('div', lang='en')
        div_en.set('class', 'col')
        parent.append(div_en)
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
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

        # アンカー設定
        name_slug = x.get('slugifiedName') or None
        if name_slug:
            name_slug += '-' + self.lang

        # 見出しレベル設定
        pn = p.get('pn')
        _, num, _ = self.split_pn(pn)
        num += '.'
        level = min([6, self.level_of_section_num(num) + 1])
        tag = 'h%d' % level

        header = build(tag, id=name_slug, lang=self.lang)
        h.append(header)
        if name_slug:
            a_title = build('a', href='#%s'%name_slug)
            a_title.set('class', 'selfRef')
        else:
            a_title = build('span')
        self.inline_text_renderer(a_title, x)
        header.append(a_title)
        return h

    def render1_t(self, h, x):
        p = build('p')
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
        target  = x.get('target')
        format  = x.get('format')
        section = x.get('section')
        relative= x.get('relative')
        reftext = x.get('derivedContent', '')
        in_name = len(list(x.iterancestors('name'))) > 0
        content = ''.join(x.itertext()).strip()
        if not (section or relative):
            a = build('a', href='#%s-%s'%(target, self.lang))
            a.text = reftext
            a.tail = x.tail
            h.append(a)
            return a
        else:
            label = 'Section' if section[0].isdigit() else 'Appendix' if re.search(r'^[A-Z](\.|$)', section) else 'Part'
            link = x.get('derivedLink')
            format  = x.get('sectionFormat')
            exptext = ("%s " % x.text.strip()) if (x.text and x.text.strip()) else ''

            if format == 'of':
                pass # TODO
            elif format == 'comma':
                pass # TODO
            elif format == 'parens':
                pass # TODO
            elif format == 'bare':
                pass # TODO

    # eref
    # <a href="https://..." class="eref">the text</a>
    def render1_eref(self, h, x):
        target = x.get('target')
        brackets = x.get('brackets') or 'none'
        if x.text:
            a = build('a', href=target)
            a.text = x.text
            a.set('class', 'eref')
            h.append(a)
            return a
        else:
            if brackets == 'none':
                a = build('a', href=target)
                a.text = target
                a.set('class', 'eref')
                span = build('span')
                span.append(a)
                h.append(span)
                return span
            elif brackets == 'angle':
                a = build('a', href=target)
                a.text = target
                a.set('class', 'eref')
                span = build('span')
                span.text = '<'
                span.tail = '>'
                span.append(a)
                h.append(span)
                return span

    # 表のレンダリング
    def render1_table(self, h, x):
        # 自己参照用のアンカー
        name = x.find('name')
        name_slug = None
        if name != None:
            name_slug = name.get('slugifiedName')
            if name_slug:
                h.append(build('span', id='%s-%s'%(name_slug,self.lang)))
        
        anchor = x.get('anchor')
        if anchor:
            h.append(build('span', id='%s-%s'%(anchor,self.lang)))

        pn = x.get('pn')
        table = build('table', id='%s-%s'%(pn,self.lang))
        h.append(table)

        # キャプション
        caption = build('caption')
        table.append(caption)
        a = build('a', href='#%s-%s'%(pn,self.lang))
        text = pn.split('-', 1)
        if self.lang == 'ja':
            if text[0] == 'table':
                text[0] = '表'
            else:
                text[0] = text[0].title()
        else:
            text[0] = text[0].title()
        a.text = ' '.join(text)
        a.set('class', 'selfRef')
        caption.append(a)
        if name != None and name_slug:
            a.tail = ':\n'
            aa = build('a', href='#%s-%s'%(name_slug,self.lang))
            aa.set('class', 'selfRef')
            caption.append(aa)
            self.inline_text_renderer(aa, name)
        for c in x:
            self.render1(table, c)
        return table

    def render1_thead(self, h, x):
        thead = build('thead')
        h.append(thead)
        for c in x:
            self.render1(thead, c)
        return thead

    def render1_tbody(self, h, x):
        tbody = build('tbody')
        h.append(tbody)
        for c in x:
            self.render1(tbody, c)
        return tbody

    def render1_tr(self, h, x):
        tr = build('tr')
        h.append(tr)
        for c in x:
            self.render1(tr, c)
        return tr

    def render1_th(self, h, x):
        th = build('th')
        h.append(th)
        if x.get('align'):
            th.set('class', 'text-' + x.get('align'))
        if x.get('colspan'):
            th.set('colspan', x.get('colspan'))
        if x.get('rowspan'):
            th.set('rowspan', x.get('rowspan'))
        self.inline_text_renderer(th, x)
        return th

    def render1_td(self, h, x):
        td = build('td')
        h.append(td)
        if x.get('align'):
            td.set('class', 'text-' + x.get('align'))
        if x.get('colspan'):
            td.set('colspan', x.get('colspan'))
        if x.get('rowspan'):
            td.set('rowspan', x.get('rowspan'))
        self.inline_text_renderer(td, x)
        return td

    def render1_em(self, h, x):
        em = build('em')
        h.append(em)
        return em

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

    # 番号付きリスト
    def render1_ul(self, h, x):
        ul = build('ul')
        h.append(ul)
        for c in x:
            self.render1(ul, c)
        return ul

    def render1_li(self, h, x):
        li = build('li')
        h.append(li)
        for c in x:
            self.render1(li, c)
        return li

    @staticmethod
    def split_pn(pn):
        """Split a pn into meaningful parts

        Returns a tuple (element_type, section_number, paragraph_number).
        If there is no paragraph number, it will be None.
        """
        parts = pn.split('-', 2)
        elt_type = parts[0]
        sect_num = parts[1]
        paragraph_num = parts[2] if len(parts) > 2 else None

        # see if section num needs special handling
        components = sect_num.split('.', 1)
        if components[0] in ['appendix', 'boilerplate', 'note', 'toc']:
            sect_num = components[1]  # these always have a second component
        return elt_type, sect_num, paragraph_num

    @staticmethod
    def level_of_section_num(num):
        """Determine hierarchy level of a section number

        Top level items have level 1. N.B., num is a string.
        """
        num_with_no_trailing_dot = num.rstrip('.')
        components = num_with_no_trailing_dot.split('.')
        if any([len(cpt) == 0 for cpt in components]):
            log.warn('Empty section number component in "{}"'.format(num))
        return len(components)

def main():
    rfc_number = sys.argv[1]
    parserEN = xml2rfc.XmlRfcParser("src/en/rfc%s.xml" % (rfc_number,))
    rfcEN = parserEN.parse()
    parserJA = xml2rfc.XmlRfcParser("src/ja/rfc%s.xml" % (rfc_number,))
    rfcJA = parserJA.parse()

    writer = HtmlWriter(rfcEN, rfcJA)
    writer.write(rfc_number)

if __name__ == "__main__":
    main()
