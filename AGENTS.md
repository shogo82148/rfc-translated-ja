# AGENTS.md

このリポジトリで作業する AI コーディングエージェント向けの指示です。

## プロジェクトの目的

このリポジトリは RFC 文書の日本語訳を管理し、英日対訳の HTML ページを生成します。

- 主な編集対象ソース: `src/ja/rfc*.xml`
- レンダリング時に使う英語側ソース: `src/en/rfc*.xml`
- 生成されるサイト出力: `docs/rfc*.html`

## セットアップ

作業ディレクトリはプロジェクトルートを使用してください。

1. Python 依存関係: `pip install -r requirements.txt`
2. Perl 依存関係: `cpanm --installdeps .`
3. Node 依存関係: `npm install`

## 主要コマンド

- 全 HTML を生成: `make`
- 1 つの RFC HTML を生成: `scripts/xml2html.py <rfc-number>`
- 日本語 XML を lint: `npm run textlint`
- 日本語 XML 内の TOC メタデータを更新: `scripts/update-toc.pl`
- JA と EN-raw のパッチを再生成: `scripts/update-patch.pl`

## 正本データと編集境界

以下は編集してよい領域です。

- `src/ja/rfc*.xml`（日本語訳コンテンツ）
- `scripts/*.pl` と `scripts/*.py`（ツール類）
- `data/xml2rfc-ja.css` と `data/xml2rfc-ja.js`（レンダリングのスタイル・挙動）

以下は生成物または同期物として扱ってください（明示的な依頼がない限り手編集しないこと）。

- `src/rfcs/`（同期された RFC 原本）
- `docs/rfc*.html`（ビルド出力）
- `src/patches/rfc*.patch`（生成された差分）

## 翻訳規約

訳語を新規に作る前に、次のドキュメントに従ってください。

- BCP14 用語: [bcp14.md](bcp14.md)
- ボイラープレート文: [boilerplate.md](boilerplate.md)
- lint ルールと用語統一: [.textlintrc.json](.textlintrc.json)

### 日本語文の統一

- **文体**: すべての日本語訳は「ですます調」で統一してください。「である」「ではある」などの文語形は避けてください。
- **例外**: 複雑な修飾句内など、文法上必要な場合のみ「である」の使用を認めます。

### BCP14 キーワードのタグ形式

RFC 2119 の BCP14 キーワード（MUST, SHOULD, MAY など）は、以下のタグ形式で記述してください：

```xml
<bcp14>日本語表現（ENGLISH_KEYWORD）</bcp14>
```

**例**：

- `<bcp14>しなければなりません（MUST）</bcp14>`
- `<bcp14>すべきです（SHOULD）</bcp14>`
- `<bcp14>してもよいです（MAY）</bcp14>`

詳細は [bcp14.md](bcp14.md) を参照してください。

### カタカナ表記の統一

- もとのつづりの終わりが -er、-or、-ar, -y の場合、語尾に「ー」をつけてください。

**例**

- セキュリティー (security)
- ヘッダー (header)
- パラメーター (parameter)
- モニター (monitor)
- フィルター (filter)
- モーター (motor)
- サーバー (server)
- ユーザー (user)
- メモリー (memory)
- テクノロジー (technology)
- カテゴリー (category)
- カウンター (counter)
- エントリー (entry)

詳細は [.textlintrc.json](.textlintrc.json) を参照してください。

## プロジェクト固有の注意点

- `scripts/xml2html.py` では対訳出力時の HTML ID 重複を避ける必要があります。anchor/id ロジックを変更する場合は、EN/JA の ID を必ず区別してください（例: 言語サフィックスを付与）。
- `src/en/rfc*.xml` は、XML 原本からコピーされるものと `scripts/txt2xml.pl` により TXT から生成されるものが混在します（規則は `Makefile` を参照）。すべて同一の生成経路だと仮定しないでください。
- `src/ja/rfc*.xml` を変更した場合は、完了前に lint を実行してください: `npm run textlint`。
- 日本語訳の修正時は、以下を確認してください：
  - **文体の統一**: 全文が「ですます調」で統一されているか
  - **BCP14 タグの形式**: `<bcp14>日本語表現（KEYWORD）</bcp14>` の形式に統一されているか（textlint の `bcp14` ルールで検証可）
  - **技術用語**: [.textlintrc.json](.textlintrc.json) に定義された用語辞書に従っているか

## 最初に読む推奨ファイル

- [Makefile](Makefile)
- [README.md](README.md)
- [src/rfcs/README.md](src/rfcs/README.md)
- [scripts/xml2html.py](scripts/xml2html.py)

## 変更時チェックリスト

変更を完了する前に次を確認してください。

1. 変更したファイルに応じた build/lint コマンドを実行する。
2. 変更は最小限に保ち、XML 翻訳の広範な再フォーマットを避ける。
3. 翻訳ファイルを変更した場合、patch ファイル再生成の要否を確認する。
