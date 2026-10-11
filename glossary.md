# 翻訳メモリー（用語集）

`src/ja/*.xml` の既存訳（50 件）から、よく出てくる単語や用語の英和訳をまとめたものです。
新しい RFC を翻訳するときは、ここにある訳語を優先して使ってください。
BCP14 キーワードは [bcp14.md](bcp14.md)、定型文は [boilerplate.md](boilerplate.md)、カタカナの長音などの機械的な規則は [.textlintrc.json](.textlintrc.json) を参照してください。

訳語の選び方:

- 既存訳で多数派の訳語を採用しています。「避ける表記」は、既存訳に少数ある別表記です。
- 初出の専門用語は「認可サーバー（authorization server）」のように原語を併記します。
- 「英語のまま」と書いたものは、プロトコル要素名・レジストリー値・固有名詞などで、訳さずにそのまま使います。

## 文書・RFC 一般

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| document | 文書 | ドキュメント |
| specification | 仕様 | |
| section | セクション | 節 |
| appendix | 付録 | |
| implementation | 実装 | |
| implementer | 実装者 | |
| reference | 参照 | |
| example | 例 | |
| note（「Note:」で始まる注記） | 注： | 注記：、注意：（Caution は「注意：」） |
| for example | たとえば | 例えば |
| therefore | したがって | 「従って」は「〜に従って（follow）」の意味でのみ使う |
| out of scope | 範囲外 | 対象外 |
| deprecated | 非推奨 | |
| obsolete | 廃止 | |
| backward compatible | 後方互換 | |
| interoperable / interoperability | 相互運用可能 / 相互運用性 | |
| robust / robustness | 堅牢 / 堅牢性 | |
| opaque | 不透明 | |
| valid / invalid | 有効 / 無効 | |
| well-formed | 整形式 | |
| canonical | 正規 | |
| case-sensitive / case-insensitive | 大文字と小文字を区別する / 区別しない | |

## 通信の当事者

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| client | クライアント | |
| server | サーバー | サーバ |
| user | ユーザー | 利用者（「HTTP の利用者」など、人を指す文脈では可） |
| user agent | ユーザーエージェント | |
| browser | ブラウザー | ブラウザ |
| sender | 送信者 | 送信側 |
| receiver | 受信者 | 受信側 |
| recipient | 受信者 | |
| endpoint | エンドポイント | |
| peer | ピア | |
| intermediary | 仲介者 | 中間者 |
| proxy | プロキシー | プロキシ |
| reverse proxy | リバースプロキシー | |
| gateway | ゲートウェイ | |
| tunnel | トンネル | |
| origin server | オリジンサーバー | |
| attacker | 攻撃者 | |
| entity | エンティティー | |
| change controller | 変更管理者 | |

## HTTP（RFC 9110〜9114）

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| request / response | リクエスト / レスポンス | 要求 / 応答（一般動詞としての「要求する」「応答する」は可） |
| connection | コネクション | 接続（一般的な「接続性」などは可） |
| message | メッセージ | |
| resource | リソース | |
| representation | 表現 | |
| content | コンテンツ | 内容 |
| request content | リクエストコンテンツ | |
| payload | ペイロード | |
| field / field name / field value | フィールド / フィールド名 / フィールド値 | |
| field line / field line value | フィールド行 / フィールド行の値 | |
| field section | フィールドセクション | |
| header field / header section | ヘッダーフィールド / ヘッダーセクション | |
| trailer field / trailer section | トレーラーフィールド / トレーラーセクション | |
| pseudo-header field | 擬似ヘッダーフィールド | |
| control data | 制御データ | |
| status code | ステータスコード | 理由句は英語のまま（例: 421（Misdirected Request）） |
| method | メソッド | メソッド名は英語のまま（GET、CONNECT など） |
| target URI / target resource | ターゲットURI / ターゲットリソース | |
| request target | リクエストターゲット | |
| scheme | スキーム | |
| authority (URI 構成要素) | オーソリティー | |
| authoritative / authority (権限) | 権威ある / 権威 | |
| origin | オリジン | |
| query | クエリー | クエリ |
| fragment | フラグメント | |
| cache / cacheable | キャッシュ / キャッシュ可能 | |
| stale / fresh | 古い / 新鮮な | |
| validator | バリデーター | |
| safe / idempotent | 安全 / 冪等 | |
| interim response / final response | 中間レスポンス / 最終レスポンス | |
| transfer coding | 転送コーディング | |
| content coding | コンテンツコーディング | |
| malformed | 不正な形式 | |
| upstream / downstream | 上流 / 下流 | |
| hop-by-hop / end-to-end | ホップバイホップ / エンドツーエンド | |
| request smuggling | リクエストスマグリング | |
| response splitting | レスポンス分割 | |

## HTTP/2・HTTP/3・QUIC・QPACK

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| stream | ストリーム | |
| bidirectional / unidirectional stream | 双方向 / 単方向ストリーム | |
| control stream | 制御ストリーム | |
| request stream / push stream | リクエストストリーム / プッシュストリーム | |
| frame / frame type | フレーム / フレームタイプ | フレーム名は英語のまま（HEADERS、DATA など） |
| setting / setting identifier / setting value | 設定 / 設定識別子 / 設定値 | 設定名は英語のまま（SETTINGS_xxx） |
| connection error / stream error | コネクションエラー / ストリームエラー | エラーコード名は英語のまま |
| server push / push ID | サーバープッシュ / プッシュID | |
| multiplexing | 多重化 | |
| flow control / flow-control credit | フロー制御 / フロー制御クレジット | |
| congestion control | 輻輳制御 | |
| head-of-line blocking | ヘッドオブラインブロッキング | |
| handshake | ハンドシェイク | |
| idle timeout | アイドルタイムアウト | |
| graceful shutdown | 正常なシャットダウン | |
| abort / abruptly terminate | 中断 / 突然終了 | |
| reset | リセット | |
| cancel / reject | キャンセル / 拒否 | |
| retry | リトライ | 再試行も既存訳にあり |
| acknowledge / acknowledgment | 確認応答する / 確認応答 | |
| variable-length integer | 可変長整数 | |
| transport parameter | トランスポートパラメーター | |
| padding | パディング | |
| priority / prioritization | 優先度 / 優先度付け | |
| reserved | 予約済み | 予約 |
| static table / dynamic table | 静的テーブル / 動的テーブル | |
| encoder / decoder | エンコーダー / デコーダー | |
| encoder stream / decoder stream | エンコーダーストリーム / デコーダーストリーム | |
| instruction | 命令 | 命令名は英語のまま（Insert Count Increment など） |
| evict / evictable / eviction | 追い出す / 追い出し可能 / 追い出し | |
| absolute index / relative index | 絶対インデックス / 相対インデックス | |
| post-Base index | post-Baseインデックス | |
| Required Insert Count, Known Received Count, Base | 英語のまま | |
| never-indexed literal | インデックス化されないリテラル | |
| Huffman encoding | ハフマンエンコーディング | |

## WebSocket・OAuth・JOSE

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| opening handshake | 開始ハンドシェイク | オープニングハンドシェイク |
| closing handshake | 終了ハンドシェイク | |
| masking | マスキング | |
| subprotocol | サブプロトコル | |
| access token | アクセストークン | |
| bearer token | Bearerトークン | ベアラートークン |
| resource server / authorization server | リソースサーバー / 認可サーバー | |
| claim | クレーム | |
| issuer | 発行者 | |
| header parameter | ヘッダーパラメーター | |
| compact serialization | コンパクトシリアル化 | コンパクトシリアライゼーション |
| JSON Web Token | JSON Web Token（JWT） | 英語のまま |

## 暗号・セキュリティー

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| security | セキュリティー | |
| privacy | プライバシー | |
| key（暗号鍵） | 鍵 | キー。暗号以外のキー（キャッシュキー、マップや辞書のキー、データベースのキー、JSON のキー）は「キー」 |
| public key / private key | 公開鍵 / 秘密鍵 | 公開キー、プライベートキー、秘密キー |
| symmetric key | 対称鍵 | 対称キー、共通鍵 |
| key agreement | 鍵合意 | キー合意、鍵共有 |
| key management | 鍵管理 | |
| key type / key wrap | 鍵タイプ / 鍵ラップ | キータイプ、キーラップ |
| content encryption key (CEK) | コンテンツ暗号化鍵 | コンテンツ暗号化キー |
| key derivation function (KDF) | 鍵導出関数 | |
| signature / sign | 署名 / 署名する | |
| encrypt / encryption | 暗号化する / 暗号化 | |
| decrypt / decryption | 復号する / 復号 | 復号化 |
| plaintext / ciphertext | 平文 / 暗号文 | |
| nonce / salt | ノンス / ソルト | |
| hash / digest | ハッシュ / ダイジェスト | |
| authentication tag | 認証タグ | |
| message authentication code (MAC) | メッセージ認証コード（MAC） | |
| curve / elliptic curve | 曲線 / 楕円曲線 | |
| authentication / authorization | 認証 / 認可 | |
| integrity / confidentiality | 完全性 / 機密性 | 整合性（データの完全性の意味では「完全性」） |
| trusted / untrusted | 信頼できる / 信頼できない | |
| attack / threat / vulnerability | 攻撃 / 脅威 / 脆弱性 | |
| mitigate / mitigation | 緩和する / 緩和策 | |
| denial of service | サービス拒否 | |
| side channel / timing attack | サイドチャネル / タイミング攻撃 | |
| replay attack | リプレイ攻撃 | |
| request forgery | リクエストフォージェリー | |

## データ形式（JSON・CBOR・CDDL・Structured Fields）

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| octet / byte / bit | オクテット / バイト / ビット | |
| string / byte string / byte sequence | 文字列 / バイト文字列 / バイト列 | |
| character | 文字 | |
| integer / decimal / boolean | 整数 / 小数 / 真偽値 | |
| array / map / object / member | 配列 / マップ / オブジェクト / メンバー | |
| element / attribute | 要素 / 属性 | |
| tag | タグ | |
| identifier | 識別子 | |
| token | トークン | |
| parameter | パラメーター | パラメータ |
| value | 値 | |
| entry | エントリー | エントリ |
| list / inner list | リスト / インナーリスト | 内部リスト |
| dictionary | 辞書 | |
| item / bare item | アイテム / 裸のアイテム | 一般的な「項目」は可 |
| binary | バイナリー | バイナリ |
| encoding / encode / decode | エンコーディング / エンコードする / デコードする | 符号化（暗号の文脈の decode は「復号」ではない） |
| deterministic encoding | 決定論的エンコーディング | |
| serialization | シリアル化 | シリアライゼーション、直列化 |
| parse / parser | 解析する（パースする）/ パーサー | パーサ |
| whitespace | 空白 | ホワイトスペース |
| escape | エスケープ | |
| media type | メディアタイプ | |
| memory | メモリー | メモリ |
| library | ライブラリー | ライブラリ |

## IANA・登録

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| registry / registration | レジストリー / 登録 | |
| register | 登録する | |
| permanent / provisional (ステータス) | 英語のまま | |
| Specification Required, Standards Action, Expert Review, First Come First Served, IESG Approval | 英語のまま | 「仕様が必要」「標準アクション」などの訳は既存訳に少数 |
| designated expert / expert reviewer | 指定専門家 / 専門家レビュアー | |
| Private Use / Experimental Use | 英語のまま | プライベート使用、実験的使用 |
| reserved | 予約済み | |
| contact | 連絡先 | |
| this document (レジストリーの Reference 欄) | 英語のまま | 本文中の「this document」は「この文書」 |
| N/A | 該当なし | 不適用 |

## 既存訳の揺れ

既存訳で訳語がそろっていなかったものは統一し、機械的に検出できる表記は textlint の辞書に追加しました。
暗号の key（鍵／キー）のように文脈で訳し分ける語は lint で検出できないので、上の表に従って訳してください。
