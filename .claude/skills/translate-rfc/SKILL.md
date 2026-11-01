---
name: translate-rfc
description: src/rfcs/rfc<番号>.xml（XML がなければ src/rfcs/rfc<番号>.txt）を日本語に翻訳して src/ja/rfc<番号>.xml を作成し、Makefile と docs/index.html に登録して HTML を生成する。「RFC NNNN を翻訳して」と依頼されたときに使う。
argument-hint: <rfc-number>
---

# RFC の翻訳

引数で指定された RFC 番号（以下 `N`）を翻訳します。
作業前に [AGENTS.md](../../../AGENTS.md)、[bcp14.md](../../../bcp14.md)、[boilerplate.md](../../../boilerplate.md)、[glossary.md](../../../glossary.md)、[.textlintrc.json](../../../.textlintrc.json) を読んでください。
訳語や文体に迷ったら、既存の訳（例: `src/ja/rfc9457.xml`、`src/ja/rfc9651.xml`）を参考にしてください。

## 1. 準備

- `src/ja/rfcN.xml` がすでに存在する場合は、何もせずに終了してください。
- `src/rfcs/rfcN.xml` が存在する場合は、`cp src/rfcs/rfcN.xml src/ja/rfcN.xml` で英語原文をコピーし、このファイルをその場で翻訳します。
- `src/rfcs/rfcN.xml` がなく `src/rfcs/rfcN.txt` だけがある場合は、次の「TXT 形式の RFC の場合」の手順で英語 XML を作ってから翻訳します。
- どちらも存在しない場合はエラーとして終了してください。

### TXT 形式の RFC の場合

古い RFC は TXT 形式の原本しかありません。`scripts/txt2xml.pl` で TXT から英語 XML を生成し、変換の崩れを手で直した差分を `src/patches/rfcN.patch` として保存します（`Makefile` は `txt2xml.pl` の出力にこのパッチを当てて `src/en/rfcN.xml` を作ります）。

1. パッチを当てない素の出力を生成します。

   ```bash
   RFC_NO_PATCH=1 scripts/txt2xml.pl N > src/en/rfcN.xml
   ```

   `src/en/` は gitignore されています。比較用に同じ出力をスクラッチパッドにも `rfcN.raw.xml` として保存しておきます。
2. **生成結果を原文 TXT と必ず突き合わせてください。** `txt2xml.pl` は TXT を完全には再現できません。過去に見つかった崩れの例は次のとおりです。
   - 本文の欠落: 行頭から始まるラベル（例: `Time:`）以降のブロックが丸ごと抜ける
   - 見出しの取りこぼし: 付録の見出しが直前のコードブロックに混ざり、節が消える（目次の項目も欠ける）
   - 節の順序: References が `<back>` に移され、原文の番号順（例: 6 References → 7 Security Considerations）と食い違う。原文の順序に合わせ、後続の節は `<references>` の後ろ（`<back>` 内）に置く
   - 参考文献: URL が改行で分断されてアンカーやタイトルが空になる、著者が欠ける、xref の `target` の大文字小文字がアンカーと一致しない。`<seriesInfo>` は `value` 属性で書く（テキストで書くと HTML で `None` と表示される）
   - 要素の種類: 定義リスト・箇条書き・注記が `<artwork>` になる、ABNF やコードが `<t>` になる、箇条書きが項目ごとに別の `<ul>` に分かれる、表がアスキーアートになる
   - ページ境界: ページ区切りでハイフン分割された語（例: `non-` / `integral`）や、改行で切れた日付・URL
   - 著者の連絡先が欠落する
3. `src/en/rfcN.xml` を直します。方針は次のとおりです。
   - 定義の一覧は `<dl>`、箇条書きは 1 つの `<ul>`、ABNF やコードは `<sourcecode type="abnf">` / `<sourcecode type="c">`、表は `<table>`、引用は `<blockquote>`（中身は `<t>` で包む）にする
   - 本文中の `[NAME]` 形式の参照は `<xref>`、URL は `<eref>` にする
   - 目次の付録は `<xref derivedContent="Appendix A" format="default" .../>` の形式にする（既存訳にそろえる）
   - 著者の連絡先は `<section>` 内に `<author>` 要素で書く
   - `pn` 属性の採番は既存の XML（例: `src/en/rfc9457.xml`）にそろえる
4. パッチを作成し、`Makefile` と同じ手順で英語 XML が再現できることを確認します。

   ```bash
   diff -u --label '' --label '' <scratchpad>/rfcN.raw.xml src/en/rfcN.xml > src/patches/rfcN.patch
   scripts/txt2xml.pl N | cmp - src/en/rfcN.xml
   ```

   `scripts/update-patch.pl` は全 RFC のパッチを再生成するので、ここでは使わないでください。
5. `cp src/en/rfcN.xml src/ja/rfcN.xml` でコピーし、翻訳前に一度 `scripts/xml2html.py N` で HTML を生成して、英語側が正しく描画されることを確認します。英語 XML の構造を後から変えると、日本語訳もやり直しになります。

古い RFC の「このメモのステータス」は現在の定型文と内容が異なるため、`src/ja/rfc9457.xml` から写さずに原文どおりに訳してください（例: 「この文書は、インターネットコミュニティーのためのインターネット標準化過程（Internet Standards Track）のプロトコルを規定し、…」）。`Copyright (C) The Internet Society (...)` の行は英語のまま残します。末尾の Full Copyright Statement も削除せずに残し、見出しは「著作権表示全文」、本文は `Copyright (C) ...` の行を除いて訳してください（例: `src/ja/rfc3339.xml`）。`txt2xml.pl` は Full Copyright Statement を `<back>` 末尾の番号なしセクション（`anchor="full-copyright-statement"`）と目次項目として出力します。その後ろに続く RFC Editor の資金提供に関する「Acknowledgement」（単数形）も、目次に載らない番号なしセクション（`anchor="acknowledgement"`）として出力されるので、削除せずに「謝辞」として訳してください。どちらも原文どおり Authors' Addresses の後ろに来るよう、英語 XML を直すときは順序と `pn` の採番を確認してください。

## 2. 翻訳

`scripts/xml2html.py` は英語と日本語の XML を要素ごとに対応させて対訳 HTML を作ります。
そのため **要素の構造を変えてはいけません**。テキストだけを書き換えてください。

### 翻訳するもの

- `<front>` の `<title>`（`abbrev` 属性はそのまま）、`<abstract>`、`<note>`
- `<boilerplate>`（「このメモのステータス」と「著作権表示」の定型文は、自分で訳さずに `src/ja/rfc9457.xml` の `<boilerplate>` から写してください。
  RFC 番号・発行年・文書の種類（標準化過程、BCP、Informational など）に応じた箇所だけを書き換えます。
  「このメモのステータス」の 1 文目は、文書の種類に応じて次のとおりにしてください。
  - Standards Track: 「これはインターネット標準化過程（Internet Standards Track）の文書です。」
  - Best Current Practice: 「このメモは、インターネットのベストカレントプラクティス（Best Current Practice）を記述したものです。」
  - Informational: 「この文書はインターネット標準化過程（Internet Standards Track）の仕様ではなく、情報提供のために公開されています。」
  - Experimental: 「この文書はインターネット標準化過程（Internet Standards Track）の仕様ではなく、検討、実験的な実装、評価のために公開されています。」
  - Historic: 「この文書はインターネット標準化過程（Internet Standards Track）の仕様ではなく、歴史的記録のために公開されています。」
  `Copyright (c) ...` の行、「Trust Legal Provisions」「Revised BSD License」は英語のまま残します。[boilerplate.md](../../../boilerplate.md) も参照）
- 本文の `<name>`（セクション見出し、図表のタイトル）、`<t>`、`<li>`、`<dt>`、`<dd>`、`<td>`、`<th>`、`<blockquote>`、`<aside>`、`<preamble>`、`<postamble>`
- `<references>` 自体の `<name>`（例: 「引用規格」「参考文献」）
- `<sourcecode>` 内のプログラムのコメント（C の `/* ... */` など）。コメント以外のコードは 1 文字も変えないでください。
  - 行末のコメントは開始位置（`/*` の桁）を変えずに中身だけを訳します
  - 複数行のコメントは全角文字を 2 桁として数え、72 桁を目安に折り返します。カタカナ語の途中では折り返しません
  - 一覧や表のように桁をそろえたコメントは、桁ぞろえを保って訳します
  - コメントアウトされたコードや、関数名・定数名などの識別子は英語のまま残します
  - 訳したあと、コメントを取り除いたコードが英語版と一致することを確認してください

### 翻訳しないもの

- 要素名・属性値（`anchor`、`pn`、`slugifiedName`、`target` など）
- `<artwork>` の中身、`<sourcecode>` 内のコメント以外の部分、ABNF、コード例、プロトコル要素名やフィールド名、IANA レジストリーに登録する値
- `<reference>` の中身（参考文献のタイトルやアブストラクトは英語のまま）
- 著者情報（`<author>`、`<address>`）
- `<xref>`、`<eref>` などのインライン要素は残し、日本語の語順に合わせて文中の位置を移動してください（要素を消したり増やしたりしない）
  - 「要素の構造を変えない」はブロック要素（`<t>`、`<li>`、`<dd>` など）の並びのことです。`<xref>`、`<bcp14>`、`<tt>` などのインライン要素は、同じブロックの中であれば英語と違う順序に並べてかまいません（`scripts/check-translation.py` もインライン要素の順序は比較しません）
  - インライン要素の順序を英語に合わせるために、1 文を 2 文に分けたり（例:「〜しなければなりません（MUST）。その方法はセクション X で説明します。」）、参照を文末の括弧に追い出したりしないでください。「セクション X で説明するように、〜しなければなりません（MUST）。」「STREAMS_BLOCKED フレーム（セクション X）」のように、修飾先の近くに置きます
  - 「Section 4.9 of [RFC8126]」は「[RFC8126]のセクション4.9」の語順にします

### 定番の見出し

既存訳との統一のため、次の見出しはこの訳語を使ってください。

| 英語 | 日本語 |
|---|---|
| Status of This Memo | このメモのステータス |
| Copyright Notice | 著作権表示 |
| Table of Contents | 目次 |
| Introduction | はじめに |
| Terminology | 用語 |
| Notational Conventions | 表記上の規則 |
| Requirements Language | 要件言語 |
| IANA Considerations | IANAに関する考慮事項 |
| Security Considerations | セキュリティーに関する考慮事項 |
| Privacy Considerations | プライバシーに関する考慮事項 |
| References | 参考文献 |
| Normative References | 引用規格 |
| Informative References | 参考文献 |
| Acknowledgements / Acknowledgments | 謝辞 |
| Author's Address / Authors' Addresses | 著者の連絡先 |
| Examples | 例 |

「This document has no IANA actions.」は「この文書にはIANAアクションはありません。」と訳します。

「RFC Editor」は「RFCエディター」と訳します（「RFC Editor Model」は「RFCエディターモデル」）。ただし、原文の語句をそのまま引用している箇所は英語のままにします。

### 表記規約

- 文体は「ですます調」で統一します。
- BCP14 キーワードは `<bcp14>しなければなりません（MUST）</bcp14>` の形式にします（[bcp14.md](../../../bcp14.md)）。
  - 翻訳では、タグの中身を bcp14.md の一覧のどれかにします。動詞や助詞の一部はタグの外に出します（例: `しても<bcp14>よいです（MAY）</bcp14>`、`含めては<bcp14>なりません（MUST NOT）</bcp14>`、`である<bcp14>必要があります（MUST）</bcp14>`）
  - 「しなければならず」「してもよく」「してはならない」のような連用形・連体形はタグに入れられません。キーワードが 2 つ続く文は 2 文に分けるか、タグの外の言い回しを工夫します
- -er、-or、-ar、-y で終わる語のカタカナ表記は長音をつけます（セキュリティー、サーバー、パラメーターなど）。
- 用語は [glossary.md](../../../glossary.md)（翻訳メモリー）と [.textlintrc.json](../../../.textlintrc.json) の辞書に従います。
- 初出の専門用語は必要に応じて「認可サーバー（authorization server）」のように原語を併記します。

### 進め方

- ファイル全体を一度に書き直さず、セクション単位で Edit してください。大きな RFC でも途中で打ち切らず、最後まで翻訳してください。
- 機械翻訳 API（DeepL など）は使わず、自分で翻訳してください。
- 大きな RFC をセクションごとに分けてサブエージェントに並列で翻訳させる場合は、次のようにします。
  - このスキルの「2. 翻訳」の節を読むよう各サブエージェントに指示します。独自の検証スクリプトを渡す場合も、インライン要素の順序まで一致させる検査にはしないでください（順序を合わせるために不自然な訳が増えます）
  - よく出る用語の対訳表を全員に渡して訳語をそろえ、結合後に訳語の揺れ（例: retire を「リタイア」と「廃止」）を確認します
  - 結合後に `scripts/check-translation.py` と textlint をファイル全体に対して実行します

## 3. 検証と登録

次のコマンドを順に実行し、エラーがなくなるまで修正してください。
Python のコマンドは `venv` があれば `venv/bin/python` を使ってください。

1. `scripts/check-translation.py N` — XML 構造と、要素ごとの BCP14 キーワード（`<bcp14>` タグ）が英語版と一致しているか確認します（構造エラーと `bcp14 mismatch` は必ず修正）。`UNTRANSLATED` と出た箇所は訳し漏れでないか確認し、レジストリー値や固有名詞など英語のままでよいもの以外は翻訳してください。
2. `scripts/update-toc.pl` — 目次の `<xref>` のテキストを翻訳済みの見出しに合わせます。
3. `npx textlint src/ja/rfcN.xml` — lint エラーを修正します。
4. `scripts/register-rfc.py N` — `Makefile` と `docs/index.html` に登録します。TXT 形式の RFC では、`txt2xml.pl` のビルドルールと `update-english` ターゲットへの追加も行います。
5. `make docs/rfcN.html` — HTML を生成します。TXT 形式の RFC では、`src/en/rfcN.xml` を削除してから実行し、TXT → パッチ → HTML の経路で生成できることを確認してください。

最後に、生成した HTML でページ内リンクの切れや、表・定義リスト・引用の描画漏れがないことを確認してください。

`src/rfcs/` は編集しないでください。`src/patches/` は、TXT 形式の RFC で新しく `rfcN.patch` を作る場合を除いて編集しないでください。
コミットやプッシュは、依頼されたときだけ行ってください。
