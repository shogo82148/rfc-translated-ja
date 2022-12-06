#!/usr/bin/env python

import xml2rfc
import lxml

class HtmlWriter:
    def __init__(self, xmlrfcEN, xmlrfcJA):
        self._rootEN = xmlrfcEN.getroot()
        self._rootJA = xmlrfcJA.getroot()
        pass

    def write(self):
        self.render(None, self._rootEN, self._rootJA)

    def render(self, h, en, ja):
        print(en.tag, ja.tag)
        res = None
        if en.tag != ja.tag:
            raise NameError('tag name not match')

        if en.tag in (lxml.etree.PI, lxml.etree.Comment):
            tail = en.tail if en.tail and en.tail.strip() else ''
            if len(h):
                last = h[-1]
                last.tail = (last.tail or '') + tail
            else:
                h.text = (h.text or '') + tail
        else:
            func_name = "render_%s" % (en.tag.lower(),)
            func = getattr(self, func_name, None)
            if func == None:
                func = self.default_renderer
            res = func(h, en, ja)
        return res

    def default_renderer(self, h, en, ja):
        hh = None
        for c in zip(en, ja):
            self.render(hh, c[0], c[1])
        return hh

def main():
    parserEN = xml2rfc.XmlRfcParser("src/en/rfc9226.xml")
    rfcEN = parserEN.parse()
    parserJA = xml2rfc.XmlRfcParser("src/ja/rfc9226.xml")
    rfcJA = parserJA.parse()

    writer = HtmlWriter(rfcEN, rfcJA)
    writer.write()

if __name__ == "__main__":
    main()
