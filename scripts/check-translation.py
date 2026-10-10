#!/usr/bin/env python3
"""Check that src/ja/rfc<number>.xml can be rendered against the English source.

Usage:
    scripts/check-translation.py [--strict] <rfc-number>

It verifies that:
  - the Japanese XML is well-formed,
  - both trees have the same element structure (scripts/xml2html.py zips them),
  - no paragraph-like element outside the references is left in English.

Exits with non-zero status on structure errors.
With --strict, elements that look untranslated are also treated as errors.
"""

import os
import re
import sys

from lxml import etree

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))

# elements whose text is expected to be translated
TEXT_TAGS = {'t', 'name', 'li', 'dd', 'dt', 'td', 'th', 'title', 'preamble', 'postamble'}
# subtrees that are kept as is
SKIP_TAGS = {'references', 'reference', 'referencegroup', 'artwork', 'sourcecode',
             'author', 'address', 'seriesInfo', 'artset'}
INLINE_TAGS = {'bcp14', 'xref', 'eref', 'em', 'strong', 'tt', 'sub', 'sup', 'cref', 'iref',
               'br', 'u', 'relref', 'spanx', 'vspace', '#comment', '#pi'}
JAPANESE =re.compile(r'[぀-ヿ㐀-鿿＀-￯]')
WORD = re.compile(r'[A-Za-z]{3,}')


def tag_of(el):
    if el.tag is etree.Comment:
        return '#comment'
    if el.tag is etree.PI:
        return '#pi'
    return el.tag


def block_children(el):
    # inline elements may be reordered by translation, so only block elements are compared
    return [c for c in el if tag_of(c) not in INLINE_TAGS]


def compare(en, ja, path, errors):
    if tag_of(en) != tag_of(ja):
        errors.append('%s: tag mismatch: en=<%s> ja=<%s>' % (path, tag_of(en), tag_of(ja)))
        return
    en_children = block_children(en)
    ja_children = block_children(ja)
    if len(en_children) != len(ja_children):
        errors.append('%s: child count mismatch: en=%d ja=%d (%s / %s)' % (
            path, len(en_children), len(ja_children),
            ' '.join(tag_of(c) for c in en_children),
            ' '.join(tag_of(c) for c in ja_children)))
    for i, (c0, c1) in enumerate(zip(en_children, ja_children)):
        compare(c0, c1, '%s/%s[%d]' % (path, tag_of(c0), i), errors)


def untranslated(ja, path, warnings):
    if not isinstance(ja.tag, str) or ja.tag in SKIP_TAGS:
        return
    if ja.tag in TEXT_TAGS:
        text = ''.join(ja.itertext()).strip()
        # skip text that has nothing to translate (numbers, identifiers, short tokens)
        # the copyright line is kept in English (see boilerplate.md)
        if text.startswith('Copyright (c)'):
            return
        if text and WORD.search(text) and not JAPANESE.search(text) and len(text.split()) >= 4:
            pn = ja.get('pn') or ja.get('slugifiedName') or path
            warnings.append('%s: looks untranslated: %s' % (pn, text[:80]))
            return
    for i, c in enumerate(ja):
        untranslated(c, '%s/%s[%d]' % (path, tag_of(c), i), warnings)


def main():
    args = sys.argv[1:]
    strict = '--strict' in args
    args = [a for a in args if a != '--strict']
    if len(args) != 1:
        print(__doc__, file=sys.stderr)
        return 2
    number = int(args[0])
    en_path = os.path.join(ROOT, 'src', 'rfcs', 'rfc%d.xml' % number)
    ja_path = os.path.join(ROOT, 'src', 'ja', 'rfc%d.xml' % number)

    try:
        ja = etree.parse(ja_path).getroot()
    except etree.XMLSyntaxError as e:
        print('%s: not well-formed: %s' % (ja_path, e))
        return 1
    en = etree.parse(en_path).getroot()

    errors = []
    compare(en, ja, '/rfc', errors)
    warnings = []
    for part in ('front', 'middle', 'back'):
        el = ja.find(part)
        if el is not None:
            untranslated(el, '/rfc/' + part, warnings)

    for e in errors:
        print('ERROR ' + e)
    for w in warnings:
        print('UNTRANSLATED ' + w)
    print('%d structure error(s), %d untranslated element(s)' % (len(errors), len(warnings)))
    return 1 if errors or (strict and warnings) else 0


if __name__ == '__main__':
    sys.exit(main())
