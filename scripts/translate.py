#!/usr/bin/env python

import xml2rfc
import lxml
import re
import openai
from io import StringIO
import os
import sys

api_key = os.environ.get('CHAT_GPT_KEY')
openai.api_key = api_key

def translate(text):
    print("Input:", text)
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
                {
                    "role": "user",
                    "content": "You are professional around RFCs. " +
                        "I will the snippet of RFC text, please translate it into Japanese. " +
                        'The key words "<bcp14>MUST</bcp14>", "<bcp14>MUST NOT</bcp14>", "<bcp14>REQUIRED</bcp14>", "<bcp14>SHALL</bcp14>", "<bcp14>SHALL NOT</bcp14>", "<bcp14>SHOULD</bcp14>", "<bcp14>SHOULD NOT</bcp14>", "<bcp14>RECOMMENDED</bcp14>", "<bcp14>NOT RECOMMENDED</bcp14>", "<bcp14>MAY</bcp14>", and "<bcp14>OPTIONAL</bcp14>" should be translated into 「<bcp14>しなければなりません（MUST）</bcp14>」、「<bcp14>してはなりません（MUST NOT）</bcp14>」、 「<bcp14>要求されています（REQUIRED）</bcp14>」、 「<bcp14>することになります（SHALL）</bcp14>」、「<bcp14>することはありません（SHALL NOT）</bcp14>」、 「<bcp14>すべきです（SHOULD）</bcp14>」、「<bcp14>すべきではありません（SHOULD NOT）</bcp14>」、 「<bcp14>推奨されます（RECOMMENDED）</bcp14>」、「<bcp14>推奨されません（NOT RECOMMENDED）</bcp14>」、 「<bcp14>してもよいです（MAY）</bcp14>」、「<bcp14>選択できます（OPTIONAL）</bcp14>」.' +
                        'Note that the input and output are XML texts. Translate the following English text to Japanese:\n\n' + text
                },
            ]
    )
    translated_text = response['choices'][0]['message']['content']
    print("Output:", translated_text)
    print()
    return translated_text

def stringify_children(node):
    from lxml.etree import tostring
    from itertools import chain
    parts = []
    if node.text:
        text = node.text
        text = re.sub('[ \n\r]+', ' ', text)
        parts.append(text)
    for c in node:
        parts.append(tostring(c, encoding=str, with_tail=False))
        if c.tail:
            text = c.tail
            text = re.sub('\s+', ' ', text)
            parts.append(text)
    return ''.join(parts)

def translate_node(x):
    s = stringify_children(x)

    try:
        s = translate(s)
        y = lxml.etree.parse(StringIO('<%s>%s</%s>'%(x.tag,s,x.tag))).getroot()
        for (key, value) in x.items():
            y.set(key, value)
        x.getparent().replace(x, y)
    except:
        print("Error:", s)
        return

def walk(x):
    if x.tag == 't':
        translate_node(x)
        return
    elif x.tag == 'li':
        translate_node(x)
        return
    elif x.tag == 'references':
        return

    for c in x:
        walk(c)

def main():
    rfc_number = sys.argv[1]
    parser = xml2rfc.XmlRfcParser("src/en/rfc%s.xml" % (rfc_number,))
    rfc = parser.parse()

    root = rfc.getroot()

    walk(root)

    writer = xml2rfc.ExpandV3XmlWriter(rfc)
    writer.write("src/ja/rfc%s.xml" % (rfc_number,))

main()
