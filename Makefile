.DELETE_ON_ERROR:

.PHONY: all
all: \
	docs/rfc10065.html \
	docs/rfc10055.html \
	docs/rfc10054.html \
	docs/rfc10053.html \
	docs/rfc10052.html \
	docs/rfc10050.html \
	docs/rfc10049.html \
	docs/rfc10042.html \
	docs/rfc10041.html \
	docs/rfc10040.html \
	docs/rfc10039.html \
	docs/rfc10038.html \
	docs/rfc10037.html \
	docs/rfc10036.html \
	docs/rfc10035.html \
	docs/rfc10034.html \
	docs/rfc10033.html \
	docs/rfc10032.html \
	docs/rfc10031.html \
	docs/rfc10030.html \
	docs/rfc10029.html \
	docs/rfc10028.html \
	docs/rfc10027.html \
	docs/rfc10026.html \
	docs/rfc10024.html \
	docs/rfc10023.html \
	docs/rfc10022.html \
	docs/rfc10019.html \
	docs/rfc10018.html \
	docs/rfc10017.html \
	docs/rfc10016.html \
	docs/rfc10015.html \
	docs/rfc10014.html \
	docs/rfc10013.html \
	docs/rfc10008.html \
	docs/rfc10007.html \
	docs/rfc10006.html \
	docs/rfc10005.html \
	docs/rfc10004.html \
	docs/rfc10003.html \
	docs/rfc10002.html \
	docs/rfc10001.html \
	docs/rfc9995.html \
	docs/rfc9980.html \
	docs/rfc9964.html \
	docs/rfc9958.html \
	docs/rfc9949.html \
	docs/rfc9948.html \
	docs/rfc9692.html \
	docs/rfc9672.html \
	docs/rfc9659.html \
	docs/rfc9651.html \
	docs/rfc9650.html \
	docs/rfc9649.html \
	docs/rfc9564.html \
	docs/rfc9562.html \
	docs/rfc9515.html \
	docs/rfc9457.html \
	docs/rfc9405.html \
	docs/rfc9401.html \
	docs/rfc9285.html \
	docs/rfc9283.html \
	docs/rfc9282.html \
	docs/rfc9226.html \
	docs/rfc9225.html \
	docs/rfc9220.html \
	docs/rfc9211.html \
	docs/rfc9209.html \
	docs/rfc9205.html \
	docs/rfc9204.html \
	docs/rfc9164.html \
	docs/rfc9163.html \
	docs/rfc9114.html \
	docs/rfc9113.html \
	docs/rfc9112.html \
	docs/rfc9111.html \
	docs/rfc9110.html \
	docs/rfc9054.html \
	docs/rfc9053.html \
	docs/rfc9052.html \
	docs/rfc9036.html \
	docs/rfc8949.html \
	docs/rfc8941.html \
	docs/rfc8881.html \
	docs/rfc8813.html \
	docs/rfc8789.html \
	docs/rfc8725.html \
	docs/rfc8682.html \
	docs/rfc8610.html \
	docs/rfc8441.html \
	docs/rfc8259.html \
	docs/rfc8174.html \
	docs/rfc8152.html \
	docs/rfc7826.html \
	docs/rfc7797.html \
	docs/rfc7692.html \
	docs/rfc7636.html \
	docs/rfc7530.html \
	docs/rfc7520.html \
	docs/rfc7519.html \
	docs/rfc7518.html \
	docs/rfc7515.html \
	docs/rfc7239.html \
	docs/rfc6750.html \
	docs/rfc6716.html \
	docs/rfc6455.html \
	docs/rfc5661.html \
	docs/rfc5424.html \
	docs/rfc4949.html \
	docs/rfc3339.html \
	docs/rfc3164.html \
	docs/rfc2230.html \
	docs/rfc2229.html \
	docs/rfc2228.html \
	docs/rfc2227.html \
	docs/rfc2226.html \
	docs/rfc2225.html \
	docs/rfc2224.html \
	docs/rfc2223.html \
	docs/rfc2222.html \
	docs/rfc2221.html \
	docs/rfc2220.html \
	docs/rfc2119.html

docs/rfc10065.html: src/en/rfc10065.xml src/rfcs/rfc10065.json src/ja/rfc10065.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10065
src/en/rfc10065.xml: src/rfcs/rfc10065.xml
	cp $< $@
docs/rfc10055.html: src/en/rfc10055.xml src/rfcs/rfc10055.json src/ja/rfc10055.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10055
src/en/rfc10055.xml: src/rfcs/rfc10055.xml
	cp $< $@
docs/rfc10054.html: src/en/rfc10054.xml src/rfcs/rfc10054.json src/ja/rfc10054.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10054
src/en/rfc10054.xml: src/rfcs/rfc10054.xml
	cp $< $@
docs/rfc10053.html: src/en/rfc10053.xml src/rfcs/rfc10053.json src/ja/rfc10053.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10053
src/en/rfc10053.xml: src/rfcs/rfc10053.xml
	cp $< $@
docs/rfc10052.html: src/en/rfc10052.xml src/rfcs/rfc10052.json src/ja/rfc10052.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10052
src/en/rfc10052.xml: src/rfcs/rfc10052.xml
	cp $< $@
docs/rfc10050.html: src/en/rfc10050.xml src/rfcs/rfc10050.json src/ja/rfc10050.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10050
src/en/rfc10050.xml: src/rfcs/rfc10050.xml
	cp $< $@
docs/rfc10049.html: src/en/rfc10049.xml src/rfcs/rfc10049.json src/ja/rfc10049.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10049
src/en/rfc10049.xml: src/rfcs/rfc10049.xml
	cp $< $@
docs/rfc10042.html: src/en/rfc10042.xml src/rfcs/rfc10042.json src/ja/rfc10042.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10042
src/en/rfc10042.xml: src/rfcs/rfc10042.xml
	cp $< $@
docs/rfc10041.html: src/en/rfc10041.xml src/rfcs/rfc10041.json src/ja/rfc10041.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10041
src/en/rfc10041.xml: src/rfcs/rfc10041.xml
	cp $< $@
docs/rfc10040.html: src/en/rfc10040.xml src/rfcs/rfc10040.json src/ja/rfc10040.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10040
src/en/rfc10040.xml: src/rfcs/rfc10040.xml
	cp $< $@
docs/rfc10039.html: src/en/rfc10039.xml src/rfcs/rfc10039.json src/ja/rfc10039.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10039
src/en/rfc10039.xml: src/rfcs/rfc10039.xml
	cp $< $@
docs/rfc10038.html: src/en/rfc10038.xml src/rfcs/rfc10038.json src/ja/rfc10038.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10038
src/en/rfc10038.xml: src/rfcs/rfc10038.xml
	cp $< $@
docs/rfc10037.html: src/en/rfc10037.xml src/rfcs/rfc10037.json src/ja/rfc10037.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10037
src/en/rfc10037.xml: src/rfcs/rfc10037.xml
	cp $< $@
docs/rfc10036.html: src/en/rfc10036.xml src/rfcs/rfc10036.json src/ja/rfc10036.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10036
src/en/rfc10036.xml: src/rfcs/rfc10036.xml
	cp $< $@
docs/rfc10035.html: src/en/rfc10035.xml src/rfcs/rfc10035.json src/ja/rfc10035.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10035
src/en/rfc10035.xml: src/rfcs/rfc10035.xml
	cp $< $@
docs/rfc10034.html: src/en/rfc10034.xml src/rfcs/rfc10034.json src/ja/rfc10034.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10034
src/en/rfc10034.xml: src/rfcs/rfc10034.xml
	cp $< $@
docs/rfc10033.html: src/en/rfc10033.xml src/rfcs/rfc10033.json src/ja/rfc10033.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10033
src/en/rfc10033.xml: src/rfcs/rfc10033.xml
	cp $< $@
docs/rfc10032.html: src/en/rfc10032.xml src/rfcs/rfc10032.json src/ja/rfc10032.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10032
src/en/rfc10032.xml: src/rfcs/rfc10032.xml
	cp $< $@
docs/rfc10031.html: src/en/rfc10031.xml src/rfcs/rfc10031.json src/ja/rfc10031.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10031
src/en/rfc10031.xml: src/rfcs/rfc10031.xml
	cp $< $@
docs/rfc10030.html: src/en/rfc10030.xml src/rfcs/rfc10030.json src/ja/rfc10030.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10030
src/en/rfc10030.xml: src/rfcs/rfc10030.xml
	cp $< $@
docs/rfc10029.html: src/en/rfc10029.xml src/rfcs/rfc10029.json src/ja/rfc10029.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10029
src/en/rfc10029.xml: src/rfcs/rfc10029.xml
	cp $< $@
docs/rfc10028.html: src/en/rfc10028.xml src/rfcs/rfc10028.json src/ja/rfc10028.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10028
src/en/rfc10028.xml: src/rfcs/rfc10028.xml
	cp $< $@
docs/rfc10027.html: src/en/rfc10027.xml src/rfcs/rfc10027.json src/ja/rfc10027.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10027
src/en/rfc10027.xml: src/rfcs/rfc10027.xml
	cp $< $@
docs/rfc10026.html: src/en/rfc10026.xml src/rfcs/rfc10026.json src/ja/rfc10026.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10026
src/en/rfc10026.xml: src/rfcs/rfc10026.xml
	cp $< $@
docs/rfc10024.html: src/en/rfc10024.xml src/rfcs/rfc10024.json src/ja/rfc10024.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10024
src/en/rfc10024.xml: src/rfcs/rfc10024.xml
	cp $< $@
docs/rfc10023.html: src/en/rfc10023.xml src/rfcs/rfc10023.json src/ja/rfc10023.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10023
src/en/rfc10023.xml: src/rfcs/rfc10023.xml
	cp $< $@
docs/rfc10022.html: src/en/rfc10022.xml src/rfcs/rfc10022.json src/ja/rfc10022.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10022
src/en/rfc10022.xml: src/rfcs/rfc10022.xml
	cp $< $@
docs/rfc10019.html: src/en/rfc10019.xml src/rfcs/rfc10019.json src/ja/rfc10019.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10019
src/en/rfc10019.xml: src/rfcs/rfc10019.xml
	cp $< $@
docs/rfc10018.html: src/en/rfc10018.xml src/rfcs/rfc10018.json src/ja/rfc10018.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10018
src/en/rfc10018.xml: src/rfcs/rfc10018.xml
	cp $< $@
docs/rfc10017.html: src/en/rfc10017.xml src/rfcs/rfc10017.json src/ja/rfc10017.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10017
src/en/rfc10017.xml: src/rfcs/rfc10017.xml
	cp $< $@
docs/rfc10016.html: src/en/rfc10016.xml src/rfcs/rfc10016.json src/ja/rfc10016.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10016
src/en/rfc10016.xml: src/rfcs/rfc10016.xml
	cp $< $@
docs/rfc10015.html: src/en/rfc10015.xml src/rfcs/rfc10015.json src/ja/rfc10015.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10015
src/en/rfc10015.xml: src/rfcs/rfc10015.xml
	cp $< $@
docs/rfc10014.html: src/en/rfc10014.xml src/rfcs/rfc10014.json src/ja/rfc10014.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10014
src/en/rfc10014.xml: src/rfcs/rfc10014.xml
	cp $< $@
docs/rfc10013.html: src/en/rfc10013.xml src/rfcs/rfc10013.json src/ja/rfc10013.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10013
src/en/rfc10013.xml: src/rfcs/rfc10013.xml
	cp $< $@
docs/rfc10008.html: src/en/rfc10008.xml src/rfcs/rfc10008.json src/ja/rfc10008.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10008
src/en/rfc10008.xml: src/rfcs/rfc10008.xml
	cp $< $@
docs/rfc10007.html: src/en/rfc10007.xml src/rfcs/rfc10007.json src/ja/rfc10007.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10007
src/en/rfc10007.xml: src/rfcs/rfc10007.xml
	cp $< $@
docs/rfc10006.html: src/en/rfc10006.xml src/rfcs/rfc10006.json src/ja/rfc10006.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10006
src/en/rfc10006.xml: src/rfcs/rfc10006.xml
	cp $< $@
docs/rfc10005.html: src/en/rfc10005.xml src/rfcs/rfc10005.json src/ja/rfc10005.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10005
src/en/rfc10005.xml: src/rfcs/rfc10005.xml
	cp $< $@
docs/rfc10004.html: src/en/rfc10004.xml src/rfcs/rfc10004.json src/ja/rfc10004.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10004
src/en/rfc10004.xml: src/rfcs/rfc10004.xml
	cp $< $@
docs/rfc10003.html: src/en/rfc10003.xml src/rfcs/rfc10003.json src/ja/rfc10003.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10003
src/en/rfc10003.xml: src/rfcs/rfc10003.xml
	cp $< $@
docs/rfc10002.html: src/en/rfc10002.xml src/rfcs/rfc10002.json src/ja/rfc10002.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10002
src/en/rfc10002.xml: src/rfcs/rfc10002.xml
	cp $< $@
docs/rfc10001.html: src/en/rfc10001.xml src/rfcs/rfc10001.json src/ja/rfc10001.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 10001
src/en/rfc10001.xml: src/rfcs/rfc10001.xml
	cp $< $@
docs/rfc9995.html: src/en/rfc9995.xml src/rfcs/rfc9995.json src/ja/rfc9995.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9995
src/en/rfc9995.xml: src/rfcs/rfc9995.xml
	cp $< $@
docs/rfc9980.html: src/en/rfc9980.xml src/rfcs/rfc9980.json src/ja/rfc9980.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9980
src/en/rfc9980.xml: src/rfcs/rfc9980.xml
	cp $< $@
docs/rfc9964.html: src/en/rfc9964.xml src/rfcs/rfc9964.json src/ja/rfc9964.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9964
src/en/rfc9964.xml: src/rfcs/rfc9964.xml
	cp $< $@
docs/rfc9958.html: src/en/rfc9958.xml src/rfcs/rfc9958.json src/ja/rfc9958.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9958
src/en/rfc9958.xml: src/rfcs/rfc9958.xml
	cp $< $@
docs/rfc9949.html: src/en/rfc9949.xml src/rfcs/rfc9949.json src/ja/rfc9949.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9949
src/en/rfc9949.xml: src/rfcs/rfc9949.xml
	cp $< $@
docs/rfc9948.html: src/en/rfc9948.xml src/rfcs/rfc9948.json src/ja/rfc9948.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9948
src/en/rfc9948.xml: src/rfcs/rfc9948.xml
	cp $< $@
docs/rfc9692.html: src/en/rfc9692.xml src/rfcs/rfc9692.json src/ja/rfc9692.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9692
src/en/rfc9692.xml: src/rfcs/rfc9692.xml
	cp $< $@
docs/rfc9672.html: src/en/rfc9672.xml src/rfcs/rfc9672.json src/ja/rfc9672.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9672
src/en/rfc9672.xml: src/rfcs/rfc9672.xml
	cp $< $@
docs/rfc9659.html: src/en/rfc9659.xml src/rfcs/rfc9659.json src/ja/rfc9659.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9659
src/en/rfc9659.xml: src/rfcs/rfc9659.xml
	cp $< $@
docs/rfc9651.html: src/en/rfc9651.xml src/rfcs/rfc9651.json src/ja/rfc9651.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9651
src/en/rfc9651.xml: src/rfcs/rfc9651.xml
	cp $< $@
docs/rfc9650.html: src/en/rfc9650.xml src/rfcs/rfc9650.json src/ja/rfc9650.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9650
src/en/rfc9650.xml: src/rfcs/rfc9650.xml
	cp $< $@
docs/rfc9649.html: src/en/rfc9649.xml src/rfcs/rfc9649.json src/ja/rfc9649.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9649
src/en/rfc9649.xml: src/rfcs/rfc9649.xml
	cp $< $@
docs/rfc9564.html: src/en/rfc9564.xml src/rfcs/rfc9564.json src/ja/rfc9564.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9564
src/en/rfc9564.xml: src/rfcs/rfc9564.xml
	cp $< $@
docs/rfc9562.html: src/en/rfc9562.xml src/rfcs/rfc9562.json src/ja/rfc9562.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9562
src/en/rfc9562.xml: src/rfcs/rfc9562.xml
	cp $< $@
docs/rfc9515.html: src/en/rfc9515.xml src/rfcs/rfc9515.json src/ja/rfc9515.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9515
src/en/rfc9515.xml: src/rfcs/rfc9515.xml
	cp $< $@
docs/rfc9457.html: src/en/rfc9457.xml src/rfcs/rfc9457.json src/ja/rfc9457.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9457
src/en/rfc9457.xml: src/rfcs/rfc9457.xml
	cp $< $@
docs/rfc9405.html: src/en/rfc9405.xml src/rfcs/rfc9405.json src/ja/rfc9405.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9405
src/en/rfc9405.xml: src/rfcs/rfc9405.xml
	cp $< $@
docs/rfc9401.html: src/en/rfc9401.xml src/rfcs/rfc9401.json src/ja/rfc9401.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9401
src/en/rfc9401.xml: src/rfcs/rfc9401.xml
	cp $< $@
docs/rfc9285.html: src/en/rfc9285.xml src/rfcs/rfc9285.json src/ja/rfc9285.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9285
src/en/rfc9285.xml: src/rfcs/rfc9285.xml
	cp $< $@
docs/rfc9283.html: src/en/rfc9283.xml src/rfcs/rfc9283.json src/ja/rfc9283.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9283
src/en/rfc9283.xml: src/rfcs/rfc9283.xml
	cp $< $@
docs/rfc9282.html: src/en/rfc9282.xml src/rfcs/rfc9282.json src/ja/rfc9282.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9282
src/en/rfc9282.xml: src/rfcs/rfc9282.xml
	cp $< $@
docs/rfc9226.html: src/en/rfc9226.xml src/rfcs/rfc9226.json src/ja/rfc9226.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9226
src/en/rfc9226.xml: src/rfcs/rfc9226.xml
	cp $< $@
docs/rfc9225.html: src/en/rfc9225.xml src/rfcs/rfc9225.json src/ja/rfc9225.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9225
src/en/rfc9225.xml: src/rfcs/rfc9225.xml
	cp $< $@
docs/rfc9220.html: src/en/rfc9220.xml src/rfcs/rfc9220.json src/ja/rfc9220.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9220
src/en/rfc9220.xml: src/rfcs/rfc9220.xml
	cp $< $@
docs/rfc9211.html: src/en/rfc9211.xml src/rfcs/rfc9211.json src/ja/rfc9211.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9211
src/en/rfc9211.xml: src/rfcs/rfc9211.xml
	cp $< $@
docs/rfc9209.html: src/en/rfc9209.xml src/rfcs/rfc9209.json src/ja/rfc9209.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9209
src/en/rfc9209.xml: src/rfcs/rfc9209.xml
	cp $< $@
docs/rfc9205.html: src/en/rfc9205.xml src/rfcs/rfc9205.json src/ja/rfc9205.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9205
src/en/rfc9205.xml: src/rfcs/rfc9205.xml
	cp $< $@
docs/rfc9204.html: src/en/rfc9204.xml src/rfcs/rfc9204.json src/ja/rfc9204.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9204
src/en/rfc9204.xml: src/rfcs/rfc9204.xml
	cp $< $@
docs/rfc9164.html: src/en/rfc9164.xml src/rfcs/rfc9164.json src/ja/rfc9164.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9164
src/en/rfc9164.xml: src/rfcs/rfc9164.xml
	cp $< $@
docs/rfc9163.html: src/en/rfc9163.xml src/rfcs/rfc9163.json src/ja/rfc9163.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9163
src/en/rfc9163.xml: src/rfcs/rfc9163.xml
	cp $< $@
docs/rfc9114.html: src/en/rfc9114.xml src/rfcs/rfc9114.json src/ja/rfc9114.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9114
src/en/rfc9114.xml: src/rfcs/rfc9114.xml
	cp $< $@
docs/rfc9113.html: src/en/rfc9113.xml src/rfcs/rfc9113.json src/ja/rfc9113.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9113
src/en/rfc9113.xml: src/rfcs/rfc9113.xml
	cp $< $@
docs/rfc9112.html: src/en/rfc9112.xml src/rfcs/rfc9112.json src/ja/rfc9112.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9112
src/en/rfc9112.xml: src/rfcs/rfc9112.xml
	cp $< $@
docs/rfc9111.html: src/en/rfc9111.xml src/rfcs/rfc9111.json src/ja/rfc9111.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9111
src/en/rfc9111.xml: src/rfcs/rfc9111.xml
	cp $< $@
docs/rfc9110.html: src/en/rfc9110.xml src/rfcs/rfc9110.json src/ja/rfc9110.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9110
src/en/rfc9110.xml: src/rfcs/rfc9110.xml
	cp $< $@
docs/rfc9054.html: src/en/rfc9054.xml src/rfcs/rfc9054.json src/ja/rfc9054.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9054
src/en/rfc9054.xml: src/rfcs/rfc9054.xml
	cp $< $@
docs/rfc9053.html: src/en/rfc9053.xml src/rfcs/rfc9053.json src/ja/rfc9053.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9053
src/en/rfc9053.xml: src/rfcs/rfc9053.xml
	cp $< $@
docs/rfc9052.html: src/en/rfc9052.xml src/rfcs/rfc9052.json src/ja/rfc9052.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9052
src/en/rfc9052.xml: src/rfcs/rfc9052.xml
	cp $< $@
docs/rfc9036.html: src/en/rfc9036.xml src/rfcs/rfc9036.json src/ja/rfc9036.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 9036
src/en/rfc9036.xml: src/rfcs/rfc9036.xml
	cp $< $@
docs/rfc8949.html: src/en/rfc8949.xml src/rfcs/rfc8949.json src/ja/rfc8949.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8949
src/en/rfc8949.xml: src/rfcs/rfc8949.xml
	cp $< $@
docs/rfc8941.html: src/en/rfc8941.xml src/rfcs/rfc8941.json src/ja/rfc8941.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8941
src/en/rfc8941.xml: src/rfcs/rfc8941.xml
	cp $< $@
docs/rfc8881.html: src/en/rfc8881.xml src/rfcs/rfc8881.json src/ja/rfc8881.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8881
src/en/rfc8881.xml: src/rfcs/rfc8881.xml
	cp $< $@
docs/rfc8813.html: src/en/rfc8813.xml src/rfcs/rfc8813.json src/ja/rfc8813.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8813
src/en/rfc8813.xml: src/rfcs/rfc8813.xml
	cp $< $@
docs/rfc8789.html: src/en/rfc8789.xml src/rfcs/rfc8789.json src/ja/rfc8789.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8789
src/en/rfc8789.xml: src/rfcs/rfc8789.xml
	cp $< $@
docs/rfc8725.html: src/en/rfc8725.xml src/rfcs/rfc8725.json src/ja/rfc8725.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8725
src/en/rfc8725.xml: src/rfcs/rfc8725.xml
	cp $< $@
docs/rfc8682.html: src/en/rfc8682.xml src/rfcs/rfc8682.json src/ja/rfc8682.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8682
src/en/rfc8682.xml: src/rfcs/rfc8682.xml
	cp $< $@
docs/rfc8610.html: src/en/rfc8610.xml src/rfcs/rfc8610.json src/ja/rfc8610.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8610
src/en/rfc8610.xml: src/rfcs/rfc8610.txt src/rfcs/rfc8610.json scripts/txt2xml.pl src/patches/rfc8610.patch
	scripts/txt2xml.pl 8610 > $@
docs/rfc8441.html: src/en/rfc8441.xml src/rfcs/rfc8441.json src/ja/rfc8441.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8441
src/en/rfc8441.xml: src/rfcs/rfc8441.txt src/rfcs/rfc8441.json scripts/txt2xml.pl src/patches/rfc8441.patch
	scripts/txt2xml.pl 8441 > $@
docs/rfc8259.html: src/en/rfc8259.xml src/rfcs/rfc8259.json src/ja/rfc8259.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8259
src/en/rfc8259.xml: src/rfcs/rfc8259.txt src/rfcs/rfc8259.json scripts/txt2xml.pl src/patches/rfc8259.patch
	scripts/txt2xml.pl 8259 > $@
docs/rfc8174.html: src/en/rfc8174.xml src/rfcs/rfc8174.json src/ja/rfc8174.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8174
src/en/rfc8174.xml: src/rfcs/rfc8174.txt src/rfcs/rfc8174.json scripts/txt2xml.pl src/patches/rfc8174.patch
	scripts/txt2xml.pl 8174 > $@
docs/rfc8152.html: src/en/rfc8152.xml src/rfcs/rfc8152.json src/ja/rfc8152.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 8152
src/en/rfc8152.xml: src/rfcs/rfc8152.txt src/rfcs/rfc8152.json scripts/txt2xml.pl src/patches/rfc8152.patch
	scripts/txt2xml.pl 8152 > $@
docs/rfc7826.html: src/en/rfc7826.xml src/rfcs/rfc7826.json src/ja/rfc7826.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7826
src/en/rfc7826.xml: src/rfcs/rfc7826.txt src/rfcs/rfc7826.json scripts/txt2xml.pl src/patches/rfc7826.patch
	scripts/txt2xml.pl 7826 > $@
docs/rfc7797.html: src/en/rfc7797.xml src/rfcs/rfc7797.json src/ja/rfc7797.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7797
src/en/rfc7797.xml: src/rfcs/rfc7797.txt src/rfcs/rfc7797.json scripts/txt2xml.pl src/patches/rfc7797.patch
	scripts/txt2xml.pl 7797 > $@
docs/rfc7692.html: src/en/rfc7692.xml src/rfcs/rfc7692.json src/ja/rfc7692.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7692
src/en/rfc7692.xml: src/rfcs/rfc7692.txt src/rfcs/rfc7692.json scripts/txt2xml.pl src/patches/rfc7692.patch
	scripts/txt2xml.pl 7692 > $@
docs/rfc7636.html: src/en/rfc7636.xml src/rfcs/rfc7636.json src/ja/rfc7636.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7636
src/en/rfc7636.xml: src/rfcs/rfc7636.txt src/rfcs/rfc7636.json scripts/txt2xml.pl src/patches/rfc7636.patch
	scripts/txt2xml.pl 7636 > $@
docs/rfc7530.html: src/en/rfc7530.xml src/rfcs/rfc7530.json src/ja/rfc7530.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7530
src/en/rfc7530.xml: src/rfcs/rfc7530.txt src/rfcs/rfc7530.json scripts/txt2xml.pl src/patches/rfc7530.patch
	scripts/txt2xml.pl 7530 > $@
docs/rfc7520.html: src/en/rfc7520.xml src/rfcs/rfc7520.json src/ja/rfc7520.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7520
src/en/rfc7520.xml: src/rfcs/rfc7520.txt src/rfcs/rfc7520.json scripts/txt2xml.pl src/patches/rfc7520.patch
	scripts/txt2xml.pl 7520 > $@
docs/rfc7519.html: src/en/rfc7519.xml src/rfcs/rfc7519.json src/ja/rfc7519.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7519
src/en/rfc7519.xml: src/rfcs/rfc7519.txt src/rfcs/rfc7519.json scripts/txt2xml.pl src/patches/rfc7519.patch
	scripts/txt2xml.pl 7519 > $@
docs/rfc7518.html: src/en/rfc7518.xml src/rfcs/rfc7518.json src/ja/rfc7518.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7518
src/en/rfc7518.xml: src/rfcs/rfc7518.txt src/rfcs/rfc7518.json scripts/txt2xml.pl src/patches/rfc7518.patch
	scripts/txt2xml.pl 7518 > $@
docs/rfc7515.html: src/en/rfc7515.xml src/rfcs/rfc7515.json src/ja/rfc7515.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7515
src/en/rfc7515.xml: src/rfcs/rfc7515.txt src/rfcs/rfc7515.json scripts/txt2xml.pl src/patches/rfc7515.patch
	scripts/txt2xml.pl 7515 > $@
docs/rfc7239.html: src/en/rfc7239.xml src/rfcs/rfc7239.json src/ja/rfc7239.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 7239
src/en/rfc7239.xml: src/rfcs/rfc7239.txt src/rfcs/rfc7239.json scripts/txt2xml.pl src/patches/rfc7239.patch
	scripts/txt2xml.pl 7239 > $@
docs/rfc6750.html: src/en/rfc6750.xml src/rfcs/rfc6750.json src/ja/rfc6750.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 6750
src/en/rfc6750.xml: src/rfcs/rfc6750.txt src/rfcs/rfc6750.json scripts/txt2xml.pl src/patches/rfc6750.patch
	scripts/txt2xml.pl 6750 > $@
docs/rfc6716.html: src/en/rfc6716.xml src/rfcs/rfc6716.json src/ja/rfc6716.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 6716
src/en/rfc6716.xml: src/rfcs/rfc6716.txt src/rfcs/rfc6716.json scripts/txt2xml.pl src/patches/rfc6716.patch
	scripts/txt2xml.pl 6716 > $@
docs/rfc6455.html: src/en/rfc6455.xml src/rfcs/rfc6455.json src/ja/rfc6455.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 6455
src/en/rfc6455.xml: src/rfcs/rfc6455.txt src/rfcs/rfc6455.json scripts/txt2xml.pl src/patches/rfc6455.patch
	scripts/txt2xml.pl 6455 > $@
docs/rfc5661.html: src/en/rfc5661.xml src/rfcs/rfc5661.json src/ja/rfc5661.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 5661
src/en/rfc5661.xml: src/rfcs/rfc5661.txt src/rfcs/rfc5661.json scripts/txt2xml.pl src/patches/rfc5661.patch
	scripts/txt2xml.pl 5661 > $@
docs/rfc5424.html: src/en/rfc5424.xml src/rfcs/rfc5424.json src/ja/rfc5424.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 5424
src/en/rfc5424.xml: src/rfcs/rfc5424.txt src/rfcs/rfc5424.json scripts/txt2xml.pl src/patches/rfc5424.patch
	scripts/txt2xml.pl 5424 > $@
docs/rfc4949.html: src/en/rfc4949.xml src/rfcs/rfc4949.json src/ja/rfc4949.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 4949
src/en/rfc4949.xml: src/rfcs/rfc4949.txt src/rfcs/rfc4949.json scripts/txt2xml.pl src/patches/rfc4949.patch
	scripts/txt2xml.pl 4949 > $@
docs/rfc3339.html: src/en/rfc3339.xml src/rfcs/rfc3339.json src/ja/rfc3339.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 3339
src/en/rfc3339.xml: src/rfcs/rfc3339.txt src/rfcs/rfc3339.json scripts/txt2xml.pl src/patches/rfc3339.patch
	scripts/txt2xml.pl 3339 > $@
docs/rfc3164.html: src/en/rfc3164.xml src/rfcs/rfc3164.json src/ja/rfc3164.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 3164
src/en/rfc3164.xml: src/rfcs/rfc3164.txt src/rfcs/rfc3164.json scripts/txt2xml.pl src/patches/rfc3164.patch
	scripts/txt2xml.pl 3164 > $@
docs/rfc2230.html: src/en/rfc2230.xml src/rfcs/rfc2230.json src/ja/rfc2230.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2230
src/en/rfc2230.xml: src/rfcs/rfc2230.txt src/rfcs/rfc2230.json scripts/txt2xml.pl src/patches/rfc2230.patch
	scripts/txt2xml.pl 2230 > $@
docs/rfc2229.html: src/en/rfc2229.xml src/rfcs/rfc2229.json src/ja/rfc2229.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2229
src/en/rfc2229.xml: src/rfcs/rfc2229.txt src/rfcs/rfc2229.json scripts/txt2xml.pl src/patches/rfc2229.patch
	scripts/txt2xml.pl 2229 > $@
docs/rfc2228.html: src/en/rfc2228.xml src/rfcs/rfc2228.json src/ja/rfc2228.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2228
src/en/rfc2228.xml: src/rfcs/rfc2228.txt src/rfcs/rfc2228.json scripts/txt2xml.pl src/patches/rfc2228.patch
	scripts/txt2xml.pl 2228 > $@
docs/rfc2227.html: src/en/rfc2227.xml src/rfcs/rfc2227.json src/ja/rfc2227.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2227
src/en/rfc2227.xml: src/rfcs/rfc2227.txt src/rfcs/rfc2227.json scripts/txt2xml.pl src/patches/rfc2227.patch
	scripts/txt2xml.pl 2227 > $@
docs/rfc2226.html: src/en/rfc2226.xml src/rfcs/rfc2226.json src/ja/rfc2226.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2226
src/en/rfc2226.xml: src/rfcs/rfc2226.txt src/rfcs/rfc2226.json scripts/txt2xml.pl src/patches/rfc2226.patch
	scripts/txt2xml.pl 2226 > $@
docs/rfc2225.html: src/en/rfc2225.xml src/rfcs/rfc2225.json src/ja/rfc2225.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2225
src/en/rfc2225.xml: src/rfcs/rfc2225.txt src/rfcs/rfc2225.json scripts/txt2xml.pl src/patches/rfc2225.patch
	scripts/txt2xml.pl 2225 > $@
docs/rfc2224.html: src/en/rfc2224.xml src/rfcs/rfc2224.json src/ja/rfc2224.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2224
src/en/rfc2224.xml: src/rfcs/rfc2224.txt src/rfcs/rfc2224.json scripts/txt2xml.pl src/patches/rfc2224.patch
	scripts/txt2xml.pl 2224 > $@
docs/rfc2223.html: src/en/rfc2223.xml src/rfcs/rfc2223.json src/ja/rfc2223.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2223
src/en/rfc2223.xml: src/rfcs/rfc2223.txt src/rfcs/rfc2223.json scripts/txt2xml.pl src/patches/rfc2223.patch
	scripts/txt2xml.pl 2223 > $@
docs/rfc2222.html: src/en/rfc2222.xml src/rfcs/rfc2222.json src/ja/rfc2222.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2222
src/en/rfc2222.xml: src/rfcs/rfc2222.txt src/rfcs/rfc2222.json scripts/txt2xml.pl src/patches/rfc2222.patch
	scripts/txt2xml.pl 2222 > $@
docs/rfc2221.html: src/en/rfc2221.xml src/rfcs/rfc2221.json src/ja/rfc2221.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2221
src/en/rfc2221.xml: src/rfcs/rfc2221.txt src/rfcs/rfc2221.json scripts/txt2xml.pl src/patches/rfc2221.patch
	scripts/txt2xml.pl 2221 > $@
docs/rfc2220.html: src/en/rfc2220.xml src/rfcs/rfc2220.json src/ja/rfc2220.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2220
src/en/rfc2220.xml: src/rfcs/rfc2220.txt src/rfcs/rfc2220.json scripts/txt2xml.pl src/patches/rfc2220.patch
	scripts/txt2xml.pl 2220 > $@
docs/rfc2119.html: src/en/rfc2119.xml src/rfcs/rfc2119.json src/ja/rfc2119.xml scripts/xml2html.py data/xml2rfc-ja.css data/xml2rfc-ja.js
	scripts/xml2html.py 2119
src/en/rfc2119.xml: src/rfcs/rfc2119.txt src/rfcs/rfc2119.json scripts/txt2xml.pl src/patches/rfc2119.patch
	scripts/txt2xml.pl 2119 > $@

.PHONY: update-english
update-english:
	scripts/txt2xml.pl 8610 > src/ja/rfc8610.xml
	scripts/txt2xml.pl 8441 > src/ja/rfc8441.xml
	scripts/txt2xml.pl 8259 > src/ja/rfc8259.xml
	scripts/txt2xml.pl 8174 > src/ja/rfc8174.xml
	scripts/txt2xml.pl 8152 > src/ja/rfc8152.xml
	scripts/txt2xml.pl 7826 > src/ja/rfc7826.xml
	scripts/txt2xml.pl 7797 > src/ja/rfc7797.xml
	scripts/txt2xml.pl 7692 > src/ja/rfc7692.xml
	scripts/txt2xml.pl 7636 > src/ja/rfc7636.xml
	scripts/txt2xml.pl 7530 > src/ja/rfc7530.xml
	scripts/txt2xml.pl 7520 > src/ja/rfc7520.xml
	scripts/txt2xml.pl 7519 > src/ja/rfc7519.xml
	scripts/txt2xml.pl 7518 > src/ja/rfc7518.xml
	scripts/txt2xml.pl 7515 > src/ja/rfc7515.xml
	scripts/txt2xml.pl 7239 > src/ja/rfc7239.xml
	scripts/txt2xml.pl 6750 > src/ja/rfc6750.xml
	scripts/txt2xml.pl 6716 > src/ja/rfc6716.xml
	scripts/txt2xml.pl 6455 > src/ja/rfc6455.xml
	scripts/txt2xml.pl 5661 > src/ja/rfc5661.xml
	scripts/txt2xml.pl 5424 > src/ja/rfc5424.xml
	scripts/txt2xml.pl 4949 > src/ja/rfc4949.xml
	scripts/txt2xml.pl 3339 > src/ja/rfc3339.xml
	scripts/txt2xml.pl 3164 > src/ja/rfc3164.xml
	scripts/txt2xml.pl 2230 > src/ja/rfc2230.xml
	scripts/txt2xml.pl 2229 > src/ja/rfc2229.xml
	scripts/txt2xml.pl 2228 > src/ja/rfc2228.xml
	scripts/txt2xml.pl 2227 > src/ja/rfc2227.xml
	scripts/txt2xml.pl 2226 > src/ja/rfc2226.xml
	scripts/txt2xml.pl 2225 > src/ja/rfc2225.xml
	scripts/txt2xml.pl 2224 > src/ja/rfc2224.xml
	scripts/txt2xml.pl 2223 > src/ja/rfc2223.xml
	scripts/txt2xml.pl 2222 > src/ja/rfc2222.xml
	scripts/txt2xml.pl 2221 > src/ja/rfc2221.xml
	scripts/txt2xml.pl 2220 > src/ja/rfc2220.xml
	scripts/txt2xml.pl 2119 > src/ja/rfc2119.xml

.PHONY: update-toc
update-toc:
	scripts/update-toc.pl
