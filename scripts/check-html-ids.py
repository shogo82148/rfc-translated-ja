#!/usr/bin/env python
"""生成された HTML に重複した id 属性がないか検査する。

使い方: scripts/check-html-ids.py [HTML ファイル ...]
引数を省略した場合は docs/*.html をすべて検査する。
埋め込み SVG（<svg> 要素とその子孫）の id は対象外。
重複が 1 件でも見つかれば終了コード 1 を返す。
"""

import glob
import os
import sys
from collections import defaultdict
from html.parser import HTMLParser


class IdCollector(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = defaultdict(list)
        self.svg_depth = 0

    def handle_starttag(self, tag, attrs):
        if tag == 'svg':
            self.svg_depth += 1
        self._collect(attrs)

    def handle_startendtag(self, tag, attrs):
        if tag == 'svg':
            return
        self._collect(attrs)

    def handle_endtag(self, tag):
        if tag == 'svg' and self.svg_depth > 0:
            self.svg_depth -= 1

    def _collect(self, attrs):
        # 埋め込み SVG 内の id は原本の図をそのまま使っているため対象外とする
        if self.svg_depth > 0:
            return
        for name, value in attrs:
            if name == 'id' and value is not None:
                self.ids[value].append(self.getpos()[0])


def find_duplicate_ids(path):
    parser = IdCollector()
    with open(path, encoding='utf-8') as f:
        parser.feed(f.read())
    parser.close()
    return {id: lines for id, lines in parser.ids.items() if len(lines) > 1}


def main(argv):
    paths = argv[1:]
    if not paths:
        root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        paths = sorted(os.path.relpath(p) for p in
                       glob.glob(os.path.join(root, 'docs', '*.html')))

    failed = False
    for path in paths:
        duplicates = find_duplicate_ids(path)
        if not duplicates:
            continue
        failed = True
        print(f'{path}: {len(duplicates)} duplicate id(s)', file=sys.stderr)
        for id, lines in sorted(duplicates.items(), key=lambda x: x[1][0]):
            print(f'  {path}:{lines[0]}: id="{id}" appears {len(lines)} times '
                  f'(lines {", ".join(map(str, lines))})', file=sys.stderr)
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
