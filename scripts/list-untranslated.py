#!/usr/bin/env python3
"""Print RFC numbers that exist in src/rfcs/ (as XML) but not yet in src/ja/.

Usage:
    scripts/list-untranslated.py [--order size|asc|desc] [--max-bytes N]
                                 [--exclude N ...] [--limit N]
"""

import argparse
import os
import re
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))
RFCS_DIR = os.path.join(ROOT, 'src', 'rfcs')
JA_DIR = os.path.join(ROOT, 'src', 'ja')


def untranslated():
    for name in os.listdir(RFCS_DIR):
        m = re.fullmatch(r'rfc([0-9]+)\.xml', name)
        if not m:
            continue
        if os.path.exists(os.path.join(JA_DIR, name)):
            continue
        number = int(m.group(1))
        size = os.path.getsize(os.path.join(RFCS_DIR, name))
        yield number, size


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--order', choices=['size', 'asc', 'desc'], default='size',
                        help='sort order (default: size, smallest first)')
    parser.add_argument('--max-bytes', type=int, default=0,
                        help='skip RFCs whose XML is larger than this (0: no limit)')
    parser.add_argument('--exclude', type=int, nargs='*', default=[],
                        help='RFC numbers to skip (e.g. ones with open PRs)')
    parser.add_argument('--limit', type=int, default=0,
                        help='print at most N numbers (0: no limit)')
    args = parser.parse_args()

    exclude = set(args.exclude)
    items = [(n, s) for (n, s) in untranslated()
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
