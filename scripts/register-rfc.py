#!/usr/bin/env python3
"""Register a translated RFC (XML source) in Makefile and docs/index.html.

Usage:
    scripts/register-rfc.py <rfc-number>

src/ja/rfc<number>.xml and src/rfcs/rfc<number>.xml must exist.
Running it twice is harmless; already registered entries are left as is.
"""

import html
import os
import re
import sys

from lxml import etree

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))
MAKEFILE = os.path.join(ROOT, 'Makefile')
INDEX = os.path.join(ROOT, 'docs', 'index.html')


def read_title(path):
    tree = etree.parse(path)
    title = tree.find('./front/title')
    if title is None:
        raise RuntimeError('title not found in %s' % path)
    return re.sub(r'\s+', ' ', ''.join(title.itertext())).strip()


def update_makefile(number):
    with open(MAKEFILE, encoding='utf-8') as f:
        content = f.read()

    target = 'docs/rfc%d.html' % number
    if re.search(r'^%s:' % re.escape(target), content, re.M):
        print('Makefile: RFC %d is already registered' % number)
        return

    # add the target to the "all" list, keeping it sorted in descending order
    lines = content.split('\n')
    start = lines.index('all: \\') + 1
    end = start
    while lines[end].endswith('\\'):
        end += 1
    entries = [l.strip().rstrip('\\').strip() for l in lines[start:end + 1]]
    entries.append(target)
    entries.sort(key=lambda e: -int(re.search(r'([0-9]+)', e).group(1)))
    new_list = ['\t%s \\' % e for e in entries[:-1]] + ['\t%s' % entries[-1]]
    lines[start:end + 1] = new_list
    content = '\n'.join(lines)

    # add the build rules before the first RFC with a smaller number
    rule = (
        'docs/rfc{n}.html: src/en/rfc{n}.xml src/rfcs/rfc{n}.json src/ja/rfc{n}.xml '
        'scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js\n'
        '\tscripts/xml2html.py {n}\n'
        'src/en/rfc{n}.xml: src/rfcs/rfc{n}.xml\n'
        '\tcp $< $@\n'
    ).format(n=number)
    pos = None
    for m in re.finditer(r'^docs/rfc([0-9]+)\.html:', content, re.M):
        if int(m.group(1)) < number:
            pos = m.start()
            break
    if pos is None:
        pos = content.index('\n\n.PHONY: update-english') + 1
    content = content[:pos] + rule + content[pos:]

    with open(MAKEFILE, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Makefile: registered RFC %d' % number)


def update_index(number, title_ja, title_en):
    with open(INDEX, encoding='utf-8') as f:
        content = f.read()

    if 'href="rfc%d.html"' % number in content:
        print('docs/index.html: RFC %d is already registered' % number)
        return

    entry = (
        '        <li><a href="rfc{n}.html">RFC {n} {ja}</a>\n'
        '        (原文: <a href="https://www.rfc-editor.org/rfc/rfc{n}">{en}</a>)\n'
    ).format(n=number, ja=html.escape(title_ja, quote=False), en=html.escape(title_en, quote=False))
    pos = None
    for m in re.finditer(r'^ *<li><a href="rfc([0-9]+)\.html">', content, re.M):
        if int(m.group(1)) < number:
            pos = m.start()
            break
    if pos is None:
        pos = re.search(r'^ *</ul>', content, re.M).start()
    content = content[:pos] + entry + content[pos:]

    with open(INDEX, 'w', encoding='utf-8') as f:
        f.write(content)
    print('docs/index.html: registered RFC %d' % number)


def main():
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        return 2
    number = int(sys.argv[1])
    title_ja = read_title(os.path.join(ROOT, 'src', 'ja', 'rfc%d.xml' % number))
    title_en = read_title(os.path.join(ROOT, 'src', 'rfcs', 'rfc%d.xml' % number))
    update_makefile(number)
    update_index(number, title_ja, title_en)
    return 0


if __name__ == '__main__':
    sys.exit(main())
