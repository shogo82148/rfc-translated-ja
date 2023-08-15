#!/usr/bin/env python
# based on https://github.com/ietf-tools/xml2rfc

import calendar
import os
import re
import sys

import xml2rfc
import lxml
from lxml.html import html_parser
from lxml.html.builder import ElementMaker

from xml2rfc.util.name import ( full_author_name_expansion, short_author_role,
                                ref_author_name_first, ref_author_name_last, 
                                short_author_name_set, full_author_name_set,
                                short_org_name_set, full_org_name, )

build = ElementMaker(makeelement=html_parser.makeelement)

def wrap_ascii(tag, name, ascii, role='', classes=None):
    """Build a tag containing a name optionally formatted to show its ascii representation"""
    role = ('','') if role in ['',None] else (', ', role)
    if ascii:
        e = build(tag,
                build.span(name, classes='non-ascii'),
                ' (',
                build.span(ascii, classes='ascii'),
                ')',
                *role,
                classes=classes
            )
    else:
        e = build(tag, name, *role)
        e.set('class', classes)
    return e

def clean_text(s):
    """Replace internal use code points and various other special code points with plain equivalents"""
    # spaces
    s = re.sub(r'[\u00a0\u2028]', ' ', s)
    # hyphens
    s = s.replace(r'\u2011', '-')
    # zero-width
    s = re.sub(r'[\u200B\u2060\ue060]', '', s)
    return s.strip()

###### date time utils #####

def normalize_month(month):
    for i, m in enumerate(calendar.month_name):
        if m and m.lower().startswith(month.lower()):
            month = '%02d' % (i)
    return month

def extract_date(e):
    day = e.get('day')
    month = e.get('month')
    year = e.get('year')

    if year:
        year = int(year)
    if month:
        if not month.isdigit():
            month = normalize_month(month)
        month = int(month)
    if day:
        day = int(day)
    return year, month, day

def format_date_iso(year, month, day):
    if   year and month and day:
        return '%4d-%02d-%02d' % (year, month, day)
    elif year and month:
        return '%4d-%02d' % (year, month)
    elif year:
        return '%4d' % (year)

def format_date(year, month, day):
    if month:
        month = calendar.month_name[month]
        if day:
            date = '%s %s, %s' % (month, day, year)
        else:
            date = '%s %s' % (month, year)
    elif year:
        date = '%s' % year
    else:
        date = ''
    return date

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

class HtmlWriter:
    def __init__(self, xmlrfcEN, xmlrfcJA):
        self.root_en = xmlrfcEN.getroot()
        self.root_ja = xmlrfcJA.getroot()
        self.refname_mapping = self.get_refname_mapping()

    # 参考文献リスト
    def get_refname_mapping(self):
        reflist = self.root_en.xpath('.//references/reference|.//references/referencegroup')
        if self.root_en.get('symRefs', 'true') == 'true':
            refname_mapping = dict( (e.get('anchor'), e.get('anchor')) for e in reflist )
        else:
            refname_mapping = (dict( (e.get('anchor'), str(i+1)) for i,e in enumerate(reflist) ))
        refname_mapping.update(dict( (e.get('target'), e.get('to')) for e in self.root_en.xpath('.//displayreference') ))
        return refname_mapping

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
        self.part = 'rfc'

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
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div', lang='ja')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
        return h

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

        # アンカー
        span_en = build('span', id='%s-en'%en.get('anchor'))
        section.append(span_en)
        span_ja = build('span', id='%s-ja'%en.get('anchor'))
        section.append(span_ja)

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

    # 定義リスト
    def render_dl(self, h, en, ja):
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

    # 順序なしリスト
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

    # 順序付きリスト
    def render_ol(self, h, en, ja):
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

    # ソースコード
    def render_sourcecode(self, h, en, ja):
        parent = build('div')
        h.append(parent)
        parent.set('class', 'row')

        # 英語
        div_en = build('div')
        div_en.set('class', 'col')
        parent.append(div_en)
        self.lang = 'en'
        self.render1(div_en, en)

        # 日本語
        div_ja = build('div')
        div_ja.set('class', 'col')
        parent.append(div_ja)
        self.lang = 'ja'
        self.render1(div_ja, ja)
        return h

    # アートワーク
    def render_artwork(self, h, en, ja):
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

    # 図
    def render_figure(self, h, en, ja):
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

    # 引用
    def render_blockquote(self, h, en, ja):
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

    # 文章の最後
    def render_back(self, h, en, ja):
        for (c0, c1) in zip(en, ja):
            self.render(h, c0, c1)
        return h

    # 参考文献
    def render_references(self, h, en, ja):
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

        # セクション番号
        numbered = p.get('numbered')=='true'
        if num and numbered:
            if self.is_appendix(pn) and self.is_top_level_section(num):
                num = 'Appendix %s' % num
            a_number = build('a', id=id_for_pn(pn), href='#%s'%id_for_pn(pn))
            a_number.set('class', 'section-number selfRef')
            a_number.text = num.title()
            a_number.tail = ' '
            header.append(a_number)

        if name_slug:
            a_title = build('a', href='#%s'%name_slug)
            a_title.set('class', 'section-name selfRef')
        else:
            a_title = build('span')
        self.inline_text_renderer(a_title, x)
        header.append(a_title)
        return header

    def render1_t(self, h, x):
        p = build('p')
        h.append(p)

        if x.text:
            p.text = x.text
        for c in x:
            ret = self.render1(p, c)
        return p

    # <xref>
    def render1_xref(self, h, x):
        target  = x.get('target')
        format  = x.get('format')
        section = x.get('section')
        relative= x.get('relative')
        reftext = x.get('derivedContent', '') or x.text
        in_name = len(list(x.iterancestors('name'))) > 0
        content = ''.join(x.itertext()).strip()
        if not (section or relative):
            if target in self.refname_mapping and format != 'title':
                # 参考文献への参照
                # e.g. [RFCxxxx]
                span = build('span')
                h.append(span)
                span.text = '['
                a = build('a', href='#%s-%s'%(target, self.lang))
                span.append(a)
                a.text = reftext
                a.tail = ']'
                span.tail = x.tail
                return span
            else:
                # e.g. Table 1
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
                span = build('span')
                h.append(span)
                span.tail = x.tail
                if self.lang == 'ja':
                    # e.g. [RFCxxxx]のSection x.y.z
                    span.text = '['
                    a1 = build('a', href='#%s-%s'%(target, self.lang))
                    a1.text = reftext
                    span.append(a1)
                    a1.tail = ']の'
                    a2 = build('a', href=link)
                    a2.text = '%s %s' % (label, section)
                    span.append(a2)
                else:
                    # e.g. Section x.y.z of [RFCxxxx]
                    a1 = build('a', href=link)
                    span.append(a1)
                    a1.text = '%s %s' % (label, section)
                    a1.tail = ' of ['
                    a2 = build('a', href='#%s-%s'%(target, self.lang))
                    span.append(a2)
                    a2.text = reftext
                    a2.tail = ']'
                return span
            elif format == 'comma':
                # See [RFC9999], Section 2.3
                span = build('span')
                h.append(span)
                span.text = '%s['%exptext
                a1 = build('a', href='#%s-%s'%(target, self.lang))
                a1.text = reftext
                a1.tail = '], '
                span.append(a1)
                a2 = build('a', href=link)
                a2.text = '%s %s' % (label, section)
                span.append(a2)
                span.tail = x.tail
                return span
            elif format == 'parens':
                pass # TODO
            elif format == 'bare':
                pass # TODO

            a = build('a', href='#%s-%s'%(target, self.lang))
            a.text = reftext
            a.tail = x.tail
            h.append(a)
            return a

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
                a.tail = x.tail
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

    def render1_br(self, h, x):
        br = build('br')
        h.append(br)
        br.tail = x.tail
        return br

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
        if pn:
            table = build('table', id='%s-%s'%(pn,self.lang))
        else:
            table = build('table')
        h.append(table)

        if pn:
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
        if x.text:
            em.text = x.text
        if x.tail:
            em.tail = x.tail
        for c in x:
            self.render1(em, c)
        return em

    def render1_bcp14(self, h, x):
        bcp14 = build('span')
        h.append(bcp14)
        bcp14.set('class', 'bcp14')
        if x.text:
            bcp14.text = x.text
        if x.tail:
            bcp14.tail = x.tail
        for c in x:
            self.render1(bcp14, c)
        return bcp14

    def inline_text_renderer(self, h, x):
        h.text = x.text.lstrip() if x.text else ''
        children = list(x)
        if children:
            for c in children:
                self.render1(h, c)
            last = h[-1]
            last.tail = last.tail.rstrip() if last.tail else ''
        else:
            h.text = h.text.rstrip()
        h.tail = x.tail

    # 定義リスト
    def render1_dl(self, h, x):
        dl = build('dl')
        h.append(dl)
        for c in x:
            self.render1(dl, c)
        return dl

    def render1_dt(self, h, x):
        dt = build('dt')
        h.append(dt)
        if x.text:
            dt.text = x.text
        if x.tail:
            dt.tail = x.tail
        for c in x:
            self.render1(dt, c)
        return dt

    def render1_dd(self, h, x):
        dd = build('dd')
        h.append(dd)
        if x.text:
            dd.text = x.text
        if x.tail:
            dd.tail = x.tail
        for c in x:
            self.render1(dd, c)
        return dd

    # リスト
    def render1_ul(self, h, x):
        ul = build('ul')
        h.append(ul)
        for c in x:
            self.render1(ul, c)
        return ul

    def render1_ol(self, h, x):
        ul = build('ol')
        h.append(ul)
        for c in x:
            self.render1(ul, c)
        return ul

    def render1_li(self, h, x):
        li = build('li')
        h.append(li)
        if x.text:
            li.text = x.text
        if x.tail:
            li.tail = x.tail
        for c in x:
            self.render1(li, c)
        return li

    # ソースコード
    def render1_sourcecode(self, h, x):
        classes = 'sourcecode'
        if type:
            classes += ' lang-%s' % type
        if len(x.text.split('\n')) > 50:
            classes += ' breakable'

        div = build('div')
        div.set('class', classes)
        div.tail = x.tail
        h.append(div)
        pre = build('pre')
        pre.text = x.text
        div.append(pre)
        return div

    def render1_artwork(self, h, x):
        type = x.get('type')
        align = x.get('align', 'left')

        div = build('div', lang='')
        h.append(div)
        if type not in ['svg', 'binary-art']:
            text = x.text + ''.join(c.tail for c in x)
            text = text.expandtabs()
            text = '\n'.join(l.rstrip() for l in text.split('\n'))
            pre = build('pre')
            pre.text = text
            div.append(pre)
        return div

    def render1_figure(self, h, x):
        figure = build('figure')
        h.append(figure)
        for c in x:
            self.render1(figure, c)
        return figure

    # 引用
    def render1_blockquote(self, h, x):
        quote = build('blockquote')
        h.append(quote)
        for c in x:
            self.render1(quote, c)
        return quote

    def render1_references(self, h, x):
        self.part = x.tag
        section = build('section')
        h.append(section)
        hh = section
        for c in x:
            if c.tag in ['reference', 'referencegroup'] and hh.tag != 'dl':
                dl = build('dl')
                hh.append(dl)
                dl.set('class', 'references')
                hh = dl
            self.render1(hh, c)
        return section

    # 参考文献
    def render1_reference(self, h, x):
        p = x.getparent()
        if p.tag == 'referencegroup':
            div = build(div, id='%s-%s'%(x.get('anchor'),self.lang))
            h.append(div)
            div.text = x.div
            outer = div
            inner = div
        else:
            dt = build('dt', id='%s-%s'%(x.get('anchor'),self.lang))
            h.append(dt)
            dt.text = '[%s]' % x.get('derivedAnchor')
            dd = build('dd')
            dd.set('class', 'break')
            h.append(dd)
            outer = dt
            inner = dd

        # Deal with parts in the correct order
        for c in x.iterdescendants('author'):
            self.render1(inner, c)
        for ctag in ('title', 'refcontent', 'stream', 'seriesInfo', 'date', ):
            for c in x.iterdescendants(ctag):
                if len(inner):
                    inner[-1].tail = ', '
                self.render1(inner, c)

        if p.tag != 'referencegroup':
            # リンクを追加
            target = x.get('target')
            if len(inner):
                inner[-1].tail = ', '
            if target:
                a = build('a', href=target)
                a.text = target
                span = build('span')
                span.text = '<'
                span.append(a)
                a.tail = '>'
                inner.append(span)
        for c in x.iterdescendants('annotation'):
            self.render1(inner, c)
        return outer

    def render1_author(self, h, x):
        p = x.getparent()
        if self.part == 'front':
            pass # TODO
        elif self.part == 'back' or p.tag == 'section':
            # このドキュメントの著者
            pass
        elif self.part == 'references':
            # 参考文献の著者
            prev  = x.getprevious()
            if prev.tag == 'author':
                prev_name = ref_author_name_first(prev)[0]
            else:
                prev = None
                prev_name = ''

            next  = x.getnext()
            if next is not None and next.tag == 'author':
                after_next = next.getnext()
                if after_next is not None and after_next.tag != 'author':
                    after_next = None
            else:
                next = None
                after_next = None

            role = short_author_role(x)

            # I do not know why "prev_name == ''" is a condition only for prev, but keeping behavior
            is_first = (prev is None) or (prev_name == '')
            is_last = next is None
            is_second_to_last = (not is_last) and (after_next is None)

            # Choose name format.
            if is_last and not is_first:
                # This is the last author in a list. Use the "last author" name format.
                name, ascii = ref_author_name_last(x)
            else:
                # All other cases use the "first author" name format.
                name, ascii = ref_author_name_first(x)

            span = wrap_ascii('span', name, ascii)
            span.set('class', 'refAuthor')

            # Now determine whether the span should be trailed by a conjunction.
            tail = span.tail or ''
            if not is_last:
                # This is not the last author in the list. A conjunction may be needed.
                if not is_second_to_last:
                    # This is not last and not second-to-last, so insert a comma.
                    tail += ', '
                else:
                    # This is the second-to-last author, so 'and' is needed. May also need a comma.
                    if is_first:
                        # Both first and second-to-last means only two authors. No comma needed.
                        tail += ' and '
                    else:
                        # There must be at least 3 authors, so include a comma.
                        tail += ', and '
            span.tail = tail

            if ''.join(span.itertext()).strip():
                h.append(span)
            return span

    def render1_contact(self, h, x):
        name, ascii = full_author_name_set(x)
        span = wrap_ascii('span', name, ascii, '', classes='contact-name')
        span.tail = x.tail
        h.append(span)
        return span

    def render1_seriesinfo(self, h, x):
        name = x.get('name')
        value = x.get('value')
        if self.part == 'front':
            pass # TODO
        elif self.part == 'references':
            span = build('span')
            span.text = '%s %s' % (name, value)
            span.set('class', 'seriesInfo')
            h.append(span)
            return span

    def render1_title(self, h, x):
        span = build('span')
        h.append(span)

        pp = x.getparent().getparent()
        title = '\u2028'.join(x.itertext())
        if pp.get("quoteTitle") == 'true':
            title = '"%s"' % title
        ascii = x.get('ascii')

        if self.part == 'references':
            span = wrap_ascii('span', clean_text(title), ascii, '', classes='refTitle')
            h.append(span)
            return span
        else:
            rfc_number = self.root_en.get('number')
            h1 = build('h1', id='rfcnum')
            h1.text = 'RFC %s' % rfc_number
            h.append(h1)
            h1 = build('h1', id='title')
            h1.text = title
            h.append(h1)
            return h1

    def render1_refcontent(self, h, x):
        span = build('span')
        h.append(span)
        span.set('class', 'refContent')
        for c in x:
            self.render(span, c)

    def render1_date(self, h, x):
        have_date = x.get('day') or x.get('month') or x.get('year')
        year, month, day = extract_date(x)
        text = format_date(year, month, day)
        datetime = format_date_iso(year, month, day) if have_date else None
        if x.text and have_date:
            text = "%s (%s)" % (x.text, text)
        elif x.text:
            text = x.text
        if datetime:
            time = build('time', datetime=datetime)
            if x.getparent() == self.root_en.find('front'):
                time.set('class', 'published')
            elif list(x.iterancestors('reference')):
                time.set('class', 'refDate')
            time.text = text
            h.append(time)
        elif text:
            time = build('span')
            time.text = text
            h.append(time)
        else:
            time = None
        return time

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

    @classmethod
    def is_top_level_section(cls, num):
        return cls.level_of_section_num(num) == 1

    appendix_pn_re = re.compile(r'^section-[a-z]\.|^section-appendix\.')
    @classmethod
    def is_appendix(cls, pn):
        """Is a section with this number an appendix?"""
        return cls.appendix_pn_re.match(pn) is not None

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
