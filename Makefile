.PHONY: all
all: \
	docs/rfc9405.html \
	docs/rfc9401.html \
	docs/rfc9226.html \
	docs/rfc9225.html \
	docs/rfc9164.html \
	docs/rfc9054.html \
	docs/rfc9053.html \
	docs/rfc9052.html \
	docs/rfc8949.html \
	docs/rfc8941.html \
	docs/rfc8725.html \
	docs/rfc8174.html \
	docs/rfc8152.html \
	docs/rfc7797.html \
	docs/rfc7520.html \
	docs/rfc7519.html \
	docs/rfc7518.html \
	docs/rfc7515.html \
	docs/rfc6750.html \
	docs/rfc2119.html

docs/rfc9405.html: src/en/rfc9405.xml src/ja/rfc9405.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9405
src/en/rfc9405.xml: src/rfcs/rfc9405.xml
	cp $< $@
docs/rfc9401.html: src/en/rfc9401.xml src/ja/rfc9401.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9401
src/en/rfc9401.xml: src/rfcs/rfc9401.xml
	cp $< $@
docs/rfc9226.html: src/en/rfc9226.xml src/ja/rfc9226.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9226
src/en/rfc9226.xml: src/rfcs/rfc9226.xml
	cp $< $@
docs/rfc9225.html: src/en/rfc9225.xml src/ja/rfc9225.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9225
src/en/rfc9225.xml: src/rfcs/rfc9225.xml
	cp $< $@
docs/rfc9164.html: src/en/rfc9164.xml src/ja/rfc9164.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9164
src/en/rfc9164.xml: src/rfcs/rfc9164.xml
	cp $< $@
docs/rfc9054.html: src/en/rfc9054.xml src/ja/rfc9054.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9054
src/en/rfc9054.xml: src/rfcs/rfc9054.xml
	cp $< $@
docs/rfc9053.html: src/en/rfc9053.xml src/ja/rfc9053.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9053
src/en/rfc9053.xml: src/rfcs/rfc9053.xml
	cp $< $@
docs/rfc9052.html: src/en/rfc9052.xml src/ja/rfc9052.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9052
src/en/rfc9052.xml: src/rfcs/rfc9052.xml
	cp $< $@
docs/rfc8949.html: src/en/rfc8949.xml src/ja/rfc8949.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8949
src/en/rfc8949.xml: src/rfcs/rfc8949.xml
	cp $< $@
docs/rfc8941.html: src/en/rfc8941.xml src/ja/rfc8941.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8941
src/en/rfc8941.xml: src/rfcs/rfc8941.xml
	cp $< $@
docs/rfc8725.html: src/en/rfc8725.xml src/ja/rfc8725.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8725
src/en/rfc8725.xml: src/rfcs/rfc8725.xml
	cp $< $@
docs/rfc8174.html: src/en/rfc8174.xml src/ja/rfc8174.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8174
src/en/rfc8174.xml: src/rfcs/rfc8174.txt scripts/txt2xml.pl src/patches/rfc8174.patch
	scripts/txt2xml.pl 8174 > $@
docs/rfc8152.html: src/en/rfc8152.xml src/ja/rfc8152.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8152
src/en/rfc8152.xml: src/rfcs/rfc8152.txt scripts/txt2xml.pl src/patches/rfc8152.patch
	scripts/txt2xml.pl 8152 > $@
docs/rfc7797.html: src/en/rfc7797.xml src/ja/rfc7797.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7797
src/en/rfc7797.xml: src/rfcs/rfc7797.txt scripts/txt2xml.pl src/patches/rfc7797.patch
	scripts/txt2xml.pl 7797 > $@
docs/rfc7520.html: src/en/rfc7520.xml src/ja/rfc7520.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7520
src/en/rfc7520.xml: src/rfcs/rfc7520.txt scripts/txt2xml.pl src/patches/rfc7520.patch
	scripts/txt2xml.pl 7520 > $@
docs/rfc7519.html: src/en/rfc7519.xml src/ja/rfc7519.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7519
src/en/rfc7519.xml: src/rfcs/rfc7519.txt scripts/txt2xml.pl src/patches/rfc7519.patch
	scripts/txt2xml.pl 7519 > $@
docs/rfc7518.html: src/en/rfc7518.xml src/ja/rfc7518.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7518
src/en/rfc7518.xml: src/rfcs/rfc7518.txt scripts/txt2xml.pl src/patches/rfc7518.patch
	scripts/txt2xml.pl 7518 > $@
docs/rfc7515.html: src/en/rfc7515.xml src/ja/rfc7515.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7515
src/en/rfc7515.xml: src/rfcs/rfc7515.txt scripts/txt2xml.pl src/patches/rfc7515.patch
	scripts/txt2xml.pl 7515 > $@
docs/rfc6750.html: src/en/rfc6750.xml src/ja/rfc6750.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 6750
src/en/rfc6750.xml: src/rfcs/rfc6750.txt scripts/txt2xml.pl src/patches/rfc6750.patch
	scripts/txt2xml.pl 6750 > $@
docs/rfc2119.html: src/en/rfc2119.xml src/ja/rfc2119.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2119
src/en/rfc2119.xml: src/rfcs/rfc2119.txt scripts/txt2xml.pl src/patches/rfc2119.patch
	scripts/txt2xml.pl 2119 > $@

.PHONY: update-english
update-english:
	scripts/txt2xml.pl 8174 > src/ja/rfc8174.xml
	scripts/txt2xml.pl 8152 > src/ja/rfc8152.xml
	scripts/txt2xml.pl 7797 > src/ja/rfc7797.xml
	scripts/txt2xml.pl 7520 > src/ja/rfc7520.xml
	scripts/txt2xml.pl 7519 > src/ja/rfc7519.xml
	scripts/txt2xml.pl 7518 > src/ja/rfc7518.xml
	scripts/txt2xml.pl 7515 > src/ja/rfc7515.xml
	scripts/txt2xml.pl 6750 > src/ja/rfc6750.xml
	scripts/txt2xml.pl 2119 > src/ja/rfc2119.xml

.PHONY: update-toc
update-toc:
	scripts/update-toc.pl
