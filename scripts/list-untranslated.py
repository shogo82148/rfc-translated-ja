#!/usr/bin/env python3
"""Print RFC numbers that exist in src/rfcs/ (as XML or TXT) but not yet in src/ja/.

When both rfcN.xml and rfcN.txt exist, the XML is used as the source
(the same rule as the translate-rfc skill), and its size is used for
--order size and --max-bytes.  TXT files that only say the RFC is
available in PostScript/PDF (e.g. RFC 1124) are skipped because there is
nothing to translate.

Usage:
    scripts/list-untranslated.py [--order size|asc|desc] [--max-bytes N]
                                 [--format all|xml|txt]
                                 [--exclude N ...] [--limit N]
"""

import argparse
import os
import re
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))
RFCS_DIR = os.path.join(ROOT, 'src', 'rfcs')
JA_DIR = os.path.join(ROOT, 'src', 'ja')

# A placeholder TXT for an RFC published only in PostScript/PDF is a few
# hundred bytes long and says so, e.g. "is available only in PostScript form".
PLACEHOLDER_MAX_BYTES = 4096
PLACEHOLDER_RE = re.compile(
    r'available\s+only\s+in\s+PostScript'
    r'|available\s+in\s+\.PS\s+and\s+\.PDF'
    r'|not\s+available\s+in\s+ASCII',
    re.IGNORECASE)


def is_placeholder(path, size):
    if size > PLACEHOLDER_MAX_BYTES:
        return False
    with open(path, encoding='utf-8', errors='replace') as f:
        return PLACEHOLDER_RE.search(f.read()) is not None


def untranslated(formats):
    sources = {}  # number -> (ext, path); XML takes precedence over TXT
    for name in os.listdir(RFCS_DIR):
        m = re.fullmatch(r'rfc([0-9]+)\.(xml|txt)', name)
        if not m:
            continue
        number, ext = int(m.group(1)), m.group(2)
        if number in sources and sources[number][0] == 'xml':
            continue
        sources[number] = (ext, os.path.join(RFCS_DIR, name))

    for number, (ext, path) in sources.items():
        if ext not in formats:
            continue
        if os.path.exists(os.path.join(JA_DIR, f'rfc{number}.xml')):
            continue
        size = os.path.getsize(path)
        if ext == 'txt' and is_placeholder(path, size):
            continue
        yield number, size


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--order', choices=['size', 'asc', 'desc'], default='size',
                        help='sort order (default: size, smallest first)')
    parser.add_argument('--max-bytes', type=int, default=0,
                        help='skip RFCs whose source (XML or TXT) is larger than this (0: no limit)')
    parser.add_argument('--format', choices=['all', 'xml', 'txt'], default='all',
                        help='source format to list (default: all; '
                             'xml/txt: only RFCs whose source is XML/TXT)')
    parser.add_argument('--exclude', type=int, nargs='*', default=[],
                        help='RFC numbers to skip (e.g. ones with open PRs)')
    parser.add_argument('--limit', type=int, default=0,
                        help='print at most N numbers (0: no limit)')
    args = parser.parse_args()

    exclude = set(args.exclude)
    formats = {'xml', 'txt'} if args.format == 'all' else {args.format}
    items = [(n, s) for (n, s) in untranslated(formats)
             if n not in exclude and (args.max_bytes <= 0 or s <= args.max_bytes)]
    if args.order == 'size':
        items.sort(key=lambda x: (x[1], x[0]))
    elif args.order == 'asc':
        items.sort()
    else:
        items.sort(reverse=True)
    if args.limit > 0:
        items = items[:args.limit]

    for number, _ in items:
        print(number)
    return 0


if __name__ == '__main__':
    sys.exit(main())
