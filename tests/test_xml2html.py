"""scripts/xml2html.py の回帰テスト

実行方法: python -m unittest discover -s tests
"""
import importlib.util
import os
import unittest

import lxml.etree

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
spec = importlib.util.spec_from_file_location(
    'xml2html', os.path.join(ROOT, 'scripts', 'xml2html.py'))
xml2html = importlib.util.module_from_spec(spec)
spec.loader.exec_module(xml2html)


class Tree:
    """HtmlWriter に渡す ElementTree の代わり"""
    def __init__(self, xml):
        self.root = lxml.etree.fromstring(xml)

    def getroot(self):
        return self.root


def rfc_xml(middle):
    return ('<rfc><front/><middle><section pn="section-1">%s</section></middle>'
            '<back><references pn="section-2">'
            '<reference anchor="RFC3550"><front><title>RTP</title></front></reference>'
            '</references></back></rfc>' % middle)


def render(en_middle, ja_middle, tag):
    writer = xml2html.HtmlWriter(Tree(rfc_xml(en_middle)), Tree(rfc_xml(ja_middle)), {})
    en = writer.root_en.find('.//' + tag)
    ja = writer.root_ja.find('.//' + tag)
    h = lxml.etree.Element('div')
    writer.render(h, en, ja)
    return h


def figure_xml(name):
    return ('<figure anchor="fig-2" pn="figure-2"><name>%s</name>'
            '<artwork pn="section-1-1.1">+--+</artwork></figure>' % name)


def sourcecode_xml(text):
    return '<sourcecode type="mib" pn="section-1-1">%s</sourcecode>' % text


class TestFigureLabel(unittest.TestCase):
    def test_label_includes_xref(self):
        h = render(
            figure_xml('RTP Header According to <xref target="RFC3550" derivedContent="RFC3550"/>'),
            figure_xml('<xref target="RFC3550" derivedContent="RFC3550"/>によるRTPヘッダー'),
            'figure')
        labels = [pre.get('aria-label') for pre in h.iter('pre')]
        self.assertEqual(labels, [
            'Figure 2: RTP Header According to [RFC3550]',
            '図2: [RFC3550]によるRTPヘッダー',
        ])

    def test_caption_keeps_xref_link(self):
        h = render(
            figure_xml('RTP Header According to <xref target="RFC3550" derivedContent="RFC3550"/>'),
            figure_xml('<xref target="RFC3550" derivedContent="RFC3550"/>によるRTPヘッダー'),
            'figure')
        hrefs = [a.get('href') for a in h.iter('a')]
        self.assertEqual(hrefs, ['#RFC3550-en', '#RFC3550-ja'])
        captions = [' '.join(''.join(c.itertext()).split()) for c in h.iter('figcaption')]
        self.assertEqual(captions, [
            'Figure 2: RTP Header According to [RFC3550]',
            '図2: [RFC3550]によるRTPヘッダー',
        ])

    def test_label_without_name(self):
        xml = '<figure pn="figure-1"><artwork pn="section-1-1.1">+--+</artwork></figure>'
        h = render(xml, xml, 'figure')
        labels = [pre.get('aria-label') for pre in h.iter('pre')]
        self.assertEqual(labels, ['Figure 1', '図1'])

    def test_label_whitespace_collapsed(self):
        h = render(figure_xml('Long\n   Title'), figure_xml('長い\n   題名'), 'figure')
        labels = [pre.get('aria-label') for pre in h.iter('pre')]
        self.assertEqual(labels, ['Figure 2: Long Title', '図2: 長い 題名'])


class TestSourcecodeLang(unittest.TestCase):
    def langs(self, h):
        return [d.get('lang') for d in h.iter('div') if 'sourcecode' in (d.get('class') or '')]

    def test_untranslated_source_is_english(self):
        text = 'trillOamMib MODULE-IDENTITY -- comment'
        h = render(sourcecode_xml(text), sourcecode_xml(text), 'sourcecode')
        self.assertEqual(self.langs(h), ['en', 'en'])

    def test_translated_source_is_not_english(self):
        h = render(sourcecode_xml('-- Object Definitions'),
                   sourcecode_xml('-- オブジェクト定義'), 'sourcecode')
        self.assertEqual(self.langs(h), ['en', None])

    def test_label(self):
        text = 'x ::= 1'
        h = render(sourcecode_xml(text), sourcecode_xml(text), 'sourcecode')
        labels = [pre.get('aria-label') for pre in h.iter('pre')]
        self.assertEqual(labels, ['Source code', 'ソースコード'])


if __name__ == '__main__':
    unittest.main()
