---
name: translate-rfc
description: src/rfcs/rfc<番号>.xml を日本語に翻訳して src/ja/rfc<番号>.xml を作成し、Makefile と docs/index.html に登録して HTML を生成する。「RFC NNNN を翻訳して」と依頼されたときに使う。
argument-hint: <rfc-number>
---

# RFC の翻訳

引数で指定された RFC 番号（以下 `N`）を翻訳します。
作業前に [AGENTS.md](../../../AGENTS.md)、[bcp14.md](../../../bcp14.md)、[boilerplate.md](../../../boilerplate.md)、[.textlintrc.json](../../../.textlintrc.json) を読んでください。
訳語や文体に迷ったら、既存の訳（例: `src/ja/rfc9457.xml`、`src/ja/rfc9651.xml`）を参考にしてください。

## 1. 準備

- `src/ja/rfcN.xml` がすでに存在する場合は、何もせずに終了してください。
- `src/rfcs/rfcN.xml` が存在しない場合はエラーとして終了してください（TXT 形式の RFC はこのスキルの対象外です）。
- `cp src/rfcs/rfcN.xml src/ja/rfcN.xml` で英語原文をコピーし、このファイルをその場で翻訳します。

## 2. 翻訳

`scripts/xml2html.py` は英語と日本語の XML を要素ごとに対応させて対訳 HTML を作ります。
そのため **要素の構造を変えてはいけません**。テキストだけを書き換えてください。

### 翻訳するもの

- `<front>` の `<title>`（`abbrev` 属性はそのまま）、`<abstract>`、`<note>`
- `<boilerplate>`（[boilerplate.md](../../../boilerplate.md) と既存訳の定型文に合わせる。`Copyright (c) ...` の行は英語のまま）
- 本文の `<name>`（セクション見出し、図表のタイトル）、`<t>`、`<li>`、`<dt>`、`<dd>`、`<td>`、`<th>`、`<blockquote>`、`<aside>`、`<preamble>`、`<postamble>`
- `<references>` 自体の `<name>`（例: 「引用規格」「参考文献」）

### 翻訳しないもの

- 要素名・属性値（`anchor`、`pn`、`slugifiedName`、`target` など）
- `<artwork>`、`<sourcecode>` の中身、ABNF、コード例、プロトコル要素名やフィールド名、IANA レジストリーに登録する値
- `<reference>` の中身（参考文献のタイトルやアブストラクトは英語のまま）
- 著者情報（`<author>`、`<address>`）
- `<xref>`、`<eref>` などのインライン要素は残し、日本語の語順に合わせて文中の位置を移動してください（要素を消したり増やしたりしない）

### 表記規約

- 文体は「ですます調」で統一します。
- BCP14 キーワードは `<bcp14>しなければなりません（MUST）</bcp14>` の形式にします（[bcp14.md](../../../bcp14.md)）。
- -er、-or、-ar、-y で終わる語のカタカナ表記は長音をつけます（セキュリティー、サーバー、パラメーターなど）。
- 用語は [.textlintrc.json](../../../.textlintrc.json) の辞書に従います。
- 初出の専門用語は必要に応じて「認可サーバー（authorization server）」のように原語を併記します。

### 進め方

- ファイル全体を一度に書き直さず、セクション単位で Edit してください。大きな RFC でも途中で打ち切らず、最後まで翻訳してください。
- 機械翻訳 API（DeepL など）は使わず、自分で翻訳してください。

## 3. 検証と登録

次のコマンドを順に実行し、エラーがなくなるまで修正してください。
Python のコマンドは `venv` があれば `venv/bin/python` を使ってください。

1. `scripts/check-translation.py N` — XML 構造が英語版と一致しているか確認します（構造エラーは必ず修正）。`UNTRANSLATED` と出た箇所は訳し漏れでないか確認し、レジストリー値や固有名詞など英語のままでよいもの以外は翻訳してください。
2. `scripts/update-toc.pl` — 目次の `<xref>` のテキストを翻訳済みの見出しに合わせます。
3. `npx textlint src/ja/rfcN.xml` — lint エラーを修正します。
4. `scripts/register-rfc.py N` — `Makefile` と `docs/index.html` に登録します。
5. `make docs/rfcN.html` — HTML を生成します。

`src/rfcs/`、`src/patches/` は編集しないでください。
コミットやプッシュは、依頼されたときだけ行ってください。
