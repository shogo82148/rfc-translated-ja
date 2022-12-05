import xml2rfc

import lxml
import re
import deepl
from io import StringIO
import os

auth_key = os.environ['DEEPL_API_KEY']
translator = deepl.Translator(auth_key)

def translate(text):
    result = translator.translate_text(text, source_lang="EN", target_lang="JA", tag_handling="xml")
    return result.text

def stringify_children(node):
    from lxml.etree import tostring
    from itertools import chain
    parts = []
    if node.text:
        text = node.text
        text = re.sub('[ \n\r]+', ' ', text)
        parts.append(text)
    for c in node:
        if c.text:
            text = c.text
            text = re.sub('\s+', ' ', text)
            parts.append(text)
        parts.append(tostring(c, encoding=str, with_tail=False))
        if c.tail:
            text = c.tail
            text = re.sub('\s+', ' ', text)
            parts.append(text)
    return ''.join(parts)

def walk(x):
    if x.tag == 't':
        s = stringify_children(x)
        s = translate(s)

        y = lxml.etree.parse(StringIO('<t>'+s+'</t>')).getroot()
        for (key, value) in x.items():
            y.set(key, value)
        x.getparent().replace(x, y)
        return
    for c in x:
        walk(c)

def main():
    parser = xml2rfc.XmlRfcParser("src/en/rfc9226.xml")
    rfc = parser.parse()

    root = rfc.getroot()

    walk(root)

    writer = xml2rfc.ExpandV3XmlWriter(rfc)
    writer.write("src/ja/rfc9226.xml")

main()
