#!/usr/bin/env python3
"""Register a translated RFC in Makefile and docs/index.html.

Usage:
    scripts/register-rfc.py <rfc-number>

src/ja/rfc<number>.xml must exist, and either src/rfcs/rfc<number>.xml or,
for RFCs published as text only, src/en-txt/rfc<number>.xml (the output of
scripts/txt2xml.pl fixed by hand).
Running it twice is harmless; already registered entries are left as is.
"""

import html
import json
import os
import re
import sys

from lxml import etree

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))
MAKEFILE = os.path.join(ROOT, 'Makefile')
INDEX = os.path.join(ROOT, 'docs', 'index.html')


def normalize_title(title):
    """Normalize a title for docs/index.html, the same as Makefile.PL.

    U+2011 (NON-BREAKING HYPHEN) and U+2060 (WORD JOINER) in the RFC XML only
    control line breaks, and they get in the way of searching the index.
    """
    title = title.replace('\u2011', '-').replace('\u2060', '')
    return re.sub(r'\s+', ' ', title).strip()


def read_title(path):
    tree = etree.parse(path)
    title = tree.find('./front/title')
    if title is None:
        raise RuntimeError('title not found in %s' % path)
    return normalize_title(''.join(title.itertext()))


def read_en_title(number):
    """Read the English title in the same way as get_en_title in Makefile.PL.

    The title comes from the original XML. RFCs only in TXT use the title in
    the JSON metadata, which scripts/txt2xml.pl writes into src/en-txt/rfc<number>.xml.
    """
    xml = os.path.join(ROOT, 'src', 'rfcs', 'rfc%d.xml' % number)
    if os.path.exists(xml):
        return read_title(xml)
    with open(os.path.join(ROOT, 'src', 'rfcs', 'rfc%d.json' % number), encoding='utf-8') as f:
        return normalize_title(json.load(f).get('title') or '')


def update_makefile(number, from_txt):
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
    # the same as Makefile.PL
    source = 'src/en-txt/rfc{n}.xml' if from_txt else 'src/rfcs/rfc{n}.xml'
    en_rule = (
        'src/en/rfc{n}.xml: ' + source + '\n'
        '\tcp $< $@\n'
    )
    rule = (
        'docs/rfc{n}.html: src/en/rfc{n}.xml src/rfcs/rfc{n}.json src/ja/rfc{n}.xml '
        'scripts/xml2html.py data/xml2rfc-ja.js\n'
        '\tscripts/xml2html.py {n}\n'
        + en_rule
    ).format(n=number)
    pos = None
    for m in re.finditer(r'^docs/rfc([0-9]+)\.html:', content, re.M):
        if int(m.group(1)) < number:
            pos = m.start()
            break
    if pos is None:
        pos = content.index('\n\n.PHONY: update-toc') + 1
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
        '        <li><a href="rfc{n}.html"><span class="num">RFC {n}</span> {ja}</a>\n'
        '        <span class="en"><span class="label">原文:</span><a href="https://www.rfc-editor.org/rfc/rfc{n}">{en}</a></span>\n'
    ).format(n=number, ja=html.escape(title_ja, quote=False), en=html.escape(title_en, quote=False))
    pos = None
    for m in re.finditer(r'^ *<li><a href="rfc([0-9]+)\.html">', content, re.M):
        if int(m.group(1)) < number:
            pos = m.start()
            break
    if pos is None:
        list_start = content.index('<ul class="rfc-list">')
        pos = re.compile(r'^ *</ul>', re.M).search(content, list_start).start()
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
    from_txt = not os.path.exists(os.path.join(ROOT, 'src', 'rfcs', 'rfc%d.xml' % number))
    if from_txt and not os.path.exists(os.path.join(ROOT, 'src', 'en-txt', 'rfc%d.xml' % number)):
        print('src/en-txt/rfc%d.xml does not exist. Generate it with '
              'scripts/txt2xml.pl -o src/en-txt/rfc%d.xml %d and fix it by hand.' % (number, number, number),
              file=sys.stderr)
        return 1
    title_en = read_en_title(number)
    update_makefile(number, from_txt)
    update_index(number, title_ja, title_en)
    return 0


if __name__ == '__main__':
    sys.exit(main())
