#!/usr/bin/env python
"""生成された HTML の見出し階層を検査する。

使い方: scripts/check-html-headings.py [HTML ファイル ...]
引数を省略した場合は docs/rfc*.html をすべて検査する。

対訳 HTML では英語と日本語の見出しが交互に並ぶため、lang 属性（en / ja）を
持つ最も近い祖先で見出しを言語ごとに分け、それぞれ次の規則を確かめる。

- エラー: h1 は文書タイトル（id が rfcnum-* / title-* の RFC 番号と表題）だけに使う
- 警告: 見出しのレベルは直前の見出しより 2 段以上深くならない（例: h2 の次に h4）

見出しレベルの飛びは、原文の節番号（例: RFC 2616 は 13 の次が 13.1.1、RFC 532 は
1.0 から始まる）をそのまま反映したものがあるため、警告にとどめる。
埋め込み SVG の中は対象外。エラーが 1 件でも見つかれば終了コード 1 を返す。
"""

import glob
import os
import sys
from html.parser import HTMLParser

HEADINGS = {'h1': 1, 'h2': 2, 'h3': 3, 'h4': 4, 'h5': 5, 'h6': 6}
LANGS = ('en', 'ja')

# 終了タグを持たない要素。lang のスタックに積まない
VOID_ELEMENTS = {
    'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link',
    'meta', 'source', 'track', 'wbr',
}


class HeadingCollector(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        # (タグ名, lang) のスタック。lang を持たない要素は None
        self.stack = []
        self.svg_depth = 0
        # 言語ごとの見出しの列 [(レベル, 行番号), ...]
        self.headings = {lang: [] for lang in LANGS}

    def current_lang(self):
        for _, lang in reversed(self.stack):
            if lang in LANGS:
                return lang
        return None

    def handle_starttag(self, tag, attrs):
        if tag == 'svg':
            self.svg_depth += 1
        if tag in VOID_ELEMENTS:
            return
        lang = dict(attrs).get('lang')
        self.stack.append((tag, lang))
        if tag in HEADINGS and self.svg_depth == 0:
            lang = self.current_lang()
            if lang:
                id = dict(attrs).get('id') or ''
                is_title = id.startswith(('rfcnum-', 'title-'))
                self.headings[lang].append(
                    (HEADINGS[tag], self.getpos()[0], is_title))

    def handle_startendtag(self, tag, attrs):
        pass

    def handle_endtag(self, tag):
        if tag == 'svg' and self.svg_depth > 0:
            self.svg_depth -= 1
        # 対応する開始タグまでスタックを戻す（閉じ忘れの要素も取り除く）
        for i in range(len(self.stack) - 1, -1, -1):
            if self.stack[i][0] == tag:
                del self.stack[i:]
                break


def find_problems(path):
    parser = HeadingCollector()
    with open(path, encoding='utf-8') as f:
        parser.feed(f.read())
    parser.close()

    problems = []
    for lang in LANGS:
        headings = parser.headings[lang]
        prev = None
        for level, line, is_title in headings:
            if is_title:
                if level != 1:
                    problems.append((line, lang, 'error',
                                     f'document title is h{level}, not h1'))
            elif level == 1:
                problems.append((line, lang, 'error',
                                 'h1 is used for a heading other than the document title'))
            elif prev is not None and level > prev + 1:
                problems.append((line, lang, 'warning',
                                 f'h{level} follows h{prev} (skips a level)'))
            prev = level
    return sorted(problems)


def main(argv):
    paths = argv[1:]
    if not paths:
        root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        paths = sorted(os.path.relpath(p) for p in
                       glob.glob(os.path.join(root, 'docs', 'rfc*.html')))

    failed = False
    for path in paths:
        problems = find_problems(path)
        if not problems:
            continue
        if any(severity == 'error' for _, _, severity, _ in problems):
            failed = True
        print(f'{path}: {len(problems)} heading problem(s)', file=sys.stderr)
        for line, lang, severity, message in problems:
            print(f'  {path}:{line}: {severity}: [{lang}] {message}', file=sys.stderr)
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
