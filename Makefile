all: \
	docs/rfc9405.html \
	docs/rfc9401.html \
	docs/rfc9226.html \
	docs/rfc9225.html \
	docs/rfc8941.html \
	docs/rfc8174.html \
	docs/rfc7518.html \
	docs/rfc2119.html

docs/rfc9405.html: src/en/rfc9405.xml src/ja/rfc9405.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9405
docs/rfc9401.html: src/en/rfc9401.xml src/ja/rfc9401.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9401
docs/rfc9226.html: src/en/rfc9226.xml src/ja/rfc9226.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9226
docs/rfc9225.html: src/en/rfc9225.xml src/ja/rfc9225.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9225
docs/rfc8941.html: src/en/rfc8941.xml src/ja/rfc8941.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8941
docs/rfc8174.html: src/en/rfc8174.xml src/ja/rfc8174.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8174
docs/rfc7518.html: src/en/rfc7518.xml src/ja/rfc7518.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7518
docs/rfc2119.html: src/en/rfc2119.xml src/ja/rfc2119.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2119
