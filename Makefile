all: \
	docs/rfc9405.html \
	docs/rfc9401.html \
	docs/rfc9226.html \
	docs/rfc9225.html \
	docs/rfc8949.html \
	docs/rfc8941.html \
	docs/rfc8725.html \
	docs/rfc8174.html \
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
src/en/rfc8174.xml: src/rfcs/rfc8174.txt scripts/txt2xml.pl
	scripts/txt2xml.pl 8174 > $@
docs/rfc7518.html: src/en/rfc7518.xml src/ja/rfc7518.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7518
src/en/rfc7518.xml: src/rfcs/rfc7518.txt scripts/txt2xml.pl
	scripts/txt2xml.pl 7518 > $@
docs/rfc7515.html: src/en/rfc7515.xml src/ja/rfc7515.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7515
src/en/rfc7515.xml: src/rfcs/rfc7515.txt scripts/txt2xml.pl
	scripts/txt2xml.pl 7515 > $@
docs/rfc6750.html: src/en/rfc6750.xml src/ja/rfc6750.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 6750
src/en/rfc6750.xml: src/rfcs/rfc6750.txt scripts/txt2xml.pl
	scripts/txt2xml.pl 6750 > $@
docs/rfc2119.html: src/en/rfc2119.xml src/ja/rfc2119.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2119
src/en/rfc2119.xml: src/rfcs/rfc2119.txt scripts/txt2xml.pl
	scripts/txt2xml.pl 2119 > $@

update-english:
	scripts/txt2xml.pl 8174 > src/ja/rfc8174.xml
	scripts/txt2xml.pl 7518 > src/ja/rfc7518.xml
	scripts/txt2xml.pl 7515 > src/ja/rfc7515.xml
	scripts/txt2xml.pl 6750 > src/ja/rfc6750.xml
	scripts/txt2xml.pl 2119 > src/ja/rfc2119.xml
