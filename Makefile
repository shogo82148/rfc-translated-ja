all: docs/rfc9226.html docs/rfc9225.html
docs/rfc9226.html: src/en/rfc9226.xml src/ja/rfc9226.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9226
docs/rfc9225.html: src/en/rfc9225.xml src/ja/rfc9225.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9225
