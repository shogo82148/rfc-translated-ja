#!/usr/bin/env python3
"""日本語訳 XML から、欧文と和文の間に入れた半角スペースを取り除く。

CSS の text-autospace で欧文と和文の間に自動で空きが入るので、手で入れた半角スペースは不要になる。
xref などのインライン要素に隣接するスペースは、その要素を xml2html.py で実際に描画した結果の
先頭・末尾の文字で判定する。artwork・sourcecode・tt の中身は変更しない。

使い方: scripts/remove-autospace.py [--check] [RFC 番号または src/ja/rfcNNNN.xml ...]
引数がなければ src/ja/rfc*.xml のすべてを処理する。
"""

import argparse
import glob
import os
import re
import sys

import lxml.etree

import importlib.util

_spec = importlib.util.spec_from_file_location(
    'xml2html', os.path.join(os.path.dirname(os.path.abspath(__file__)), 'xml2html.py'))
xml2html = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(xml2html)

# 和文: かな・漢字・長音記号・全角の約物
JA = r'\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF々〆〇、。，．・：；？！（）「」『』【】〔〕［］｛｝〈〉《》'
# 欧文: 英数字（ダイアクリティカルマーク付きのラテン文字を含む）と角かっこ（e.g. [RFC2119]）
EN = r'A-Za-z0-9À-ɏ\[\]'

JA_RE = re.compile('[%s]' % JA)
EN_RE = re.compile('[%s]' % EN)

# 中身を変更しない要素
SKIP = {'artwork', 'sourcecode', 'tt', 'u'}
# 前後のスペースを描画結果で判定するインライン要素
INLINE = {'xref', 'eref', 'tt', 'em', 'strong', 'sup', 'sub', 'bcp14', 'contact', 'cref', 'relref', 'span'}

TOKEN = re.compile(
    r'(?P<comment><!--.*?-->)'
    r'|(?P<pi><\?.*?\?>)'
    r'|(?P<cdata><!\[CDATA\[.*?\]\]>)'
    r'|(?P<doctype><!DOCTYPE(?:[^\[>]|\[.*?\])*>)'
    r'|(?P<end></(?P<endname>[^\s>]+)\s*>)'
    r'|(?P<start><(?P<startname>[^\s/>!?]+)(?:[^>"\']|"[^"]*"|\'[^\']*\')*?(?P<selfclose>/)?>)'
    r'|(?P<text>[^<]+)',
    re.S)


class _Doc:
    def __init__(self, root):
        self._root = root

    def getroot(self):
        return self._root


def is_ja(c):
    return bool(c) and JA_RE.match(c) is not None


def is_en(c):
    return bool(c) and EN_RE.match(c) is not None


def process(path):
    with open(path, encoding='utf-8') as f:
        raw = f.read()

    parser = lxml.etree.XMLParser(resolve_entities=False, remove_comments=False)
    root = lxml.etree.fromstring(raw.encode('utf-8'), parser)
    elements = [e for e in root.iter() if isinstance(e.tag, str)]

    writer = xml2html.HtmlWriter(_Doc(root), _Doc(root), {})
    writer.lang = 'ja'
    cache = {}

    def rendered(el):
        key = id(el)
        if key not in cache:
            tail = el.tail
            el.tail = None
            h = lxml.etree.Element('div')
            try:
                writer.render1(h, el)
                text = ''.join(h.itertext())
            except Exception:
                text = ''
            finally:
                el.tail = tail
            cache[key] = text
        return cache[key]

    tokens = list(TOKEN.finditer(raw))
    out = []
    stack = []  # (name, element)
    idx = 0
    removed = 0

    # 各トークンに対応する要素（start/end）を記録する
    tok_el = [None] * len(tokens)
    for i, m in enumerate(tokens):
        if m.group('start'):
            el = elements[idx]
            idx += 1
            name = m.group('startname')
            assert lxml.etree.QName(el).localname == name.split(':')[-1], (path, el.tag, name)
            tok_el[i] = el
            if not m.group('selfclose'):
                stack.append(el)
        elif m.group('end'):
            el = stack.pop()
            assert lxml.etree.QName(el).localname == m.group('endname').split(':')[-1], (path, el.tag, m.group('endname'))
            tok_el[i] = el
    assert idx == len(elements), path

    def edge_before(i):
        """トークン i の直前に描画される文字（インライン要素の末尾）"""
        if i < 0:
            return ''
        m = tokens[i]
        el = tok_el[i]
        if el is None or el.tag not in INLINE:
            return ''
        if m.group('end') or (m.group('start') and m.group('selfclose')):
            s = rendered(el)
            return s[-1] if s else ''
        return ''

    def edge_after(i):
        """トークン i の位置から描画される文字（インライン要素の先頭）"""
        if i >= len(tokens):
            return ''
        m = tokens[i]
        el = tok_el[i]
        if el is None or el.tag not in INLINE or not m.group('start'):
            return ''
        s = rendered(el)
        return s[0] if s else ''

    skip_depth = 0
    for i, m in enumerate(tokens):
        s = m.group(0)
        if m.group('start'):
            if not m.group('selfclose') and m.group('startname') in SKIP:
                skip_depth += 1
            out.append(s)
            continue
        if m.group('end'):
            if m.group('endname') in SKIP:
                skip_depth -= 1
            out.append(s)
            continue
        if not m.group('text') or skip_depth > 0:
            out.append(s)
            continue

        prev_c = edge_before(i - 1)
        next_c = edge_after(i + 1)

        def repl(mm):
            nonlocal removed
            a = s[mm.start() - 1] if mm.start() > 0 else prev_c
            b = s[mm.end()] if mm.end() < len(s) else next_c
            at_edge = mm.start() == 0 or mm.end() == len(s)
            # インライン要素の境界では、和文同士の間のスペース（e.g. 「の <xref/>」→「のセクション3」）も取り除く
            if (is_ja(a) and is_en(b)) or (is_en(a) and is_ja(b)) or (at_edge and is_ja(a) and is_ja(b)):
                removed += 1
                return ''
            return mm.group(0)

        out.append(re.sub(r' +', repl, s))

    new = ''.join(out)
    return raw, new, removed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--check', action='store_true', help='書き換えずに件数だけ表示する')
    ap.add_argument('files', nargs='*')
    args = ap.parse_args()
    files = [('src/ja/rfc%s.xml' % f) if f.isdigit() else f for f in args.files] or sorted(glob.glob('src/ja/rfc*.xml'))
    total = 0
    for path in files:
        raw, new, removed = process(path)
        total += removed
        if removed and not args.check:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new)
        if removed:
            print('%s: %d' % (path, removed))
    print('total: %d' % total, file=sys.stderr)


if __name__ == '__main__':
    main()
