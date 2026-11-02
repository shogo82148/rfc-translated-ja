# 翻訳メモリー（用語集）

`src/ja/*.xml` の既存訳（812 件）から、よく出てくる単語や用語の英和訳をまとめたものです。
新しい RFC を翻訳するときは、ここにある訳語を優先して使ってください。
BCP14 キーワードは [bcp14.md](bcp14.md)、定型文は [boilerplate.md](boilerplate.md)、カタカナの長音などの機械的な規則は [.textlintrc.json](.textlintrc.json) を参照してください。

訳語の選び方:

- 英語原文（`src/en/*.xml`）と既存訳の段落を対応させ、英語の用語ごとにどの訳語が使われているかを数えて、多数派の訳語を採用しています。
- 「避ける表記」は、既存訳に少数ある別表記です。多数派と少数派の差が小さいものは備考にその旨を書いています。
- 初出の専門用語は「認可サーバー（authorization server）」のように原語を併記します。
- 「英語のまま」と書いたものは、プロトコル要素名・レジストリー値・固有名詞などで、訳さずにそのまま使います。
- この用語集にないカタカナ語は、「[外来語（カタカナ）表記ガイドライン](https://www.bunka.go.jp/seisaku/bunkashingikai/kokugo/kokugo_kadai/iinkai_45/pdf/93390601_09.pdf)」に従って表記します。
  ただし、既存訳で定着している表記（ハンドシェイク、ペイロード、プレフィックス、ウィンドウなど）は、ガイドラインと異なっていても既存訳の表記を優先します。
  interface はガイドラインでは「インターフェイス」ですが、このリポジトリーでは「インターフェース」に統一しています。

## 文書・RFC 一般

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| document | 文書 | ドキュメント |
| this document / this specification / this memo | この文書 / この仕様 / このメモ | 本文書、本書、本仕様 |
| specification | 仕様 | |
| section / subsection | セクション / サブセクション | 節、小節 |
| appendix | 付録 | |
| implementation | 実装 | |
| implementer / implementor | 実装者 | |
| implementation-specific | 実装固有 | 実装依存（implementation-dependent の訳としては可） |
| mandatory-to-implement | 実装必須 | |
| reference | 参照 | |
| example | 例 | |
| note（「Note:」で始まる注記） | 注： | 注記：、注意：（Caution は「注意：」） |
| for example | たとえば | 例えば |
| therefore | したがって | 「従って」は「〜に従って（follow）」の意味でのみ使う |
| at the time of writing | 執筆時点 | 「この文書の執筆時点」も可 |
| out of scope | 範囲外 | 対象外 |
| requirement | 要件 | 要求事項 |
| recommendation | 推奨事項 | 勧告（ITU-T などの「Recommendation」は「勧告」） |
| guideline / guidance | ガイドライン / ガイダンス | 指針 |
| use case / scenario | ユースケース / シナリオ | 使用例 |
| assumption | 前提 | 仮定、想定 |
| consideration | 考慮事項 | |
| normative / non-normative | 規範的 / 非規範的 | |
| deprecated | 非推奨 | |
| obsolete | 廃止 | |
| backward compatible / forward compatible | 後方互換 / 前方互換 | |
| interoperable / interoperability | 相互運用可能 / 相互運用性 | |
| robust / robustness | 堅牢 / 堅牢性 | |
| opaque | 不透明 | |
| valid / invalid | 有効 / 無効 | |
| well-formed | 整形式 | |
| canonical | 正規 | |
| case-sensitive / case-insensitive | 大文字と小文字を区別する / 区別しない | 大文字小文字を区別する |
| trade-off / overhead / granularity | トレードオフ / オーバーヘッド / 粒度 | |
| errata | 正誤表 | エラッタ |

## よく出る見出し

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| Table of Contents | 目次 | |
| Introduction | はじめに | 導入、序論 |
| Overview / Background / Motivation | 概要 / 背景 / 動機 | |
| Terminology / Definitions | 用語 / 定義 | |
| Conventions and Definitions | 表記規則と定義 | 規約と定義 |
| Conventions and Terminology | 表記規則と用語 | |
| Notational Conventions | 表記上の規則 | 表記法 |
| Requirements Language | 要件言語 | |
| Security Considerations | セキュリティーに関する考慮事項 | セキュリティー上の考慮事項 |
| IANA Considerations | IANAに関する考慮事項 | |
| Privacy Considerations | プライバシーに関する考慮事項 | |
| Operational Considerations | 運用上の考慮事項 | 運用に関する考慮事項 |
| Implementation Considerations | 実装に関する考慮事項 | 実装上の考慮事項 |
| Implementation Status | 実装状況 | |
| Changes from RFC NNNN | RFC NNNNからの変更 | 「変更点」も既存訳にあり |
| Acknowledgements / Acknowledgments | 謝辞 | |
| Contributors | 貢献者 | 寄稿者 |
| Normative References | 引用規格 | |
| Informative References | 参考文献 | |
| Authors' Addresses / Author's Address | 著者の連絡先 | |

## IETF・標準化プロセス

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| Standards Track | 標準化過程 | 標準トラック |
| Proposed Standard / Internet Standard | 提案標準 / インターネット標準 | |
| Best Current Practice | ベストカレントプラクティス | |
| Informational / Experimental / Historic | 情報提供 / 実験的 / 歴史的 | |
| Internet-Draft | インターネットドラフト | 参考文献の書誌情報では英語のまま |
| Work in Progress | 作業中 | 参考文献の書誌情報では英語のまま |
| working group | ワーキンググループ | 作業部会 |
| area director | エリアディレクター | |
| mailing list | メーリングリスト | |
| reviewer | レビュアー | 査読者、レビューア |
| consensus | コンセンサス | 合意（agreement の訳として使う） |
| community | コミュニティー | |

## 通信の当事者

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| client | クライアント | |
| server | サーバー | サーバ |
| user | ユーザー | 利用者（「HTTP の利用者」など、人を指す文脈では可） |
| end user | エンドユーザー | |
| user agent | ユーザーエージェント | |
| browser | ブラウザー | ブラウザ |
| sender | 送信者 | 送信側 |
| receiver | 受信者 | 受信側 |
| recipient | 受信者 | |
| endpoint | エンドポイント | 端点 |
| peer | ピア | |
| node / host | ノード / ホスト | |
| intermediary | 仲介者 | 中間者（man-in-the-middle の訳で使う） |
| proxy | プロキシー | プロキシ |
| reverse proxy | リバースプロキシー | |
| gateway | ゲートウェイ | |
| tunnel | トンネル | |
| origin server | オリジンサーバー | |
| attacker | 攻撃者 | |
| adversary | 敵対者 | 攻撃者も同程度に使われている |
| entity | エンティティー | |
| change controller | 変更管理者 | |
| operator / network operator | 運用者 / ネットワーク運用者 | オペレーター（数式の operator は「演算子」） |
| administrator | 管理者 | |
| service provider | サービスプロバイダー | サービス提供者 |
| vendor | ベンダー | |
| customer | 顧客 | カスタマー |
| third party | 第三者 | サードパーティー |
| relying party | 依拠当事者 | |
| initiator / responder | イニシエーター / レスポンダー | 開始者 / 応答者 |
| controller | コントローラー | |
| tenant | テナント | |

## プロトコル一般

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| protocol | プロトコル | |
| message | メッセージ | |
| request / response | リクエスト / レスポンス | 要求 / 応答。一般動詞としての「要求する」「応答する」は可。古い RFC の既存訳には「要求」「応答」も多い |
| request message / response message | リクエストメッセージ / レスポンスメッセージ | 要求メッセージ / 応答メッセージ |
| error code / error message | エラーコード / エラーメッセージ | |
| connection | コネクション | 接続（物理的な接続や「接続性」などは可） |
| connection establishment | コネクションの確立 | |
| session | セッション | |
| header / payload | ヘッダー / ペイロード | |
| content | コンテンツ | 内容（一般的な「〜の内容」は可） |
| interface | インターフェース | インターフェイス |
| mechanism | メカニズム | 仕組み、機構 |
| behavior | 振る舞い | 挙動（「動作」は operation の訳として使う） |
| operation | 操作 | |
| capability | 能力 | ケイパビリティー（feature、function は「機能」） |
| feature / functionality | 機能 | フィーチャー |
| component | コンポーネント | 構成要素（古い RFC の既存訳に多い） |
| item | 項目 | アイテム（Structured Fields の Item は「アイテム」） |
| layer | 層 | レイヤー |
| format | 形式 | フォーマット |
| message format / packet format / data format | メッセージ形式 / パケット形式 / データ形式 | |
| syntax / semantics | 構文 / セマンティクス | シンタックス / 意味論 |
| rule | 規則 | ルール |
| processing rule | 処理規則 | |
| scheme（URI scheme など） | スキーム | 署名方式・符号化方式などの scheme は「方式」 |
| method | 方法 | HTTP などのメソッドは「メソッド」 |
| state machine | 状態機械 | ステートマシン |
| stateless / stateful | ステートレス / ステートフル | |
| timer / timeout | タイマー / タイムアウト | |
| retry | 再試行 | リトライ |
| retransmit / retransmission | 再送する / 再送 | 再送信 |
| discard | 破棄する | 廃棄 |
| silently discard / silently ignore | 黙って破棄する / 黙って無視する | |
| ignore | 無視する | |
| unknown / unrecognized | 未知の / 認識できない | |
| malformed | 不正な形式 | |
| optional | 任意 | 省略可能、オプション（BCP14 の OPTIONAL は bcp14.md に従う） |
| mandatory | 必須 | |
| default | デフォルト | 既定 |
| support | サポートする | |
| conform / compliant | 準拠する / 準拠した | 適合（conformance は「適合」も多い） |
| negotiate / negotiation | ネゴシエートする / ネゴシエーション | 交渉 |
| extension / extensible | 拡張 / 拡張可能 | エクステンション |
| legacy | レガシー | 従来 |
| deploy / deployment | 展開する / 展開 | デプロイ、デプロイメント、配備 |
| configuration / configure | 設定 / 設定する | 構成、コンフィギュレーション |
| provisioning | プロビジョニング | |
| bootstrap / fallback | ブートストラップ / フォールバック | |
| out-of-band / in-band | 帯域外 / 帯域内 | アウトオブバンド / インバンド |
| pseudo- | 疑似 | 擬似（既存訳でほぼ半々。新規訳では疑似にそろえる） |
| pseudocode | 疑似コード | 擬似コード |
| deliver / delivery | 配送する / 配送 | 配信（メディアのストリーミング配信では可） |
| expire | 期限切れになる | 満了 |
| expiration time | 有効期限 | |
| lifetime | 有効期間 | 寿命、ライフタイム |
| notification / event | 通知 / イベント | |
| report | 報告 | レポート |
| monitoring / measurement | 監視 / 測定 | モニター、計測 |
| metric | メトリック | メトリクス、指標 |
| threshold | しきい値 | 閾値 |
| policy / local policy | ポリシー / ローカルポリシー | 方針 |
| process | プロセス | 「処理（processing）」と区別する |
| processing | 処理 | |
| primitive / callback | プリミティブ / コールバック | |
| buffer / queue / pointer | バッファー / キュー / ポインター | バッファ、ポインタ |
| container | コンテナー | コンテナ |
| framework | フレームワーク | 枠組み |

## HTTP（RFC 9110〜9114）

request / response、connection、content は「プロトコル一般」を参照してください。

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| resource | リソース | |
| representation | 表現 | |
| request content | リクエストコンテンツ | |
| message body | メッセージボディー | メールの本文は「本文」（「メール・メディア・テキスト」を参照） |
| field / field name / field value | フィールド / フィールド名 / フィールド値 | |
| field line / field line value | フィールド行 / フィールド行の値 | |
| field section | フィールドセクション | |
| header field / header section | ヘッダーフィールド / ヘッダーセクション | |
| trailer field / trailer section | トレーラーフィールド / トレーラーセクション | |
| pseudo-header field | 疑似ヘッダーフィールド | 擬似ヘッダーフィールド（RFC 9114 など一部の既存訳） |
| control data | 制御データ | |
| status code | ステータスコード | 理由句は英語のまま（例: 421（Misdirected Request）） |
| method | メソッド | メソッド名は英語のまま（GET、CONNECT など） |
| target URI / target resource | ターゲットURI / ターゲットリソース | |
| request target | リクエストターゲット | |
| scheme | スキーム | |
| authority (URI 構成要素) | オーソリティー | |
| authoritative / authority (権限) | 権威ある / 権威 | |
| origin | オリジン | |
| query | クエリー | クエリ、問い合わせ |
| fragment | フラグメント | |
| cache / cacheable | キャッシュ / キャッシュ可能 | |
| stale / fresh | 古い / 新鮮な | |
| validator | バリデーター | |
| safe / idempotent | 安全 / 冪等 | べき等 |
| interim response / final response | 中間レスポンス / 最終レスポンス | |
| transfer coding | 転送コーディング | |
| content coding | コンテンツコーディング | |
| content negotiation | コンテンツネゴシエーション | |
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
| retry | 再試行 | リトライ |
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

## トランスポート・輻輳制御

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| TCP connection / TLS connection | TCPコネクション / TLSコネクション | TCP接続 / TLS接続 |
| segment | セグメント | |
| datagram / IP datagram | データグラム / IPデータグラム | |
| sequence number | シーケンス番号 | 順序番号 |
| port number / source port / destination port | ポート番号 / 送信元ポート / 宛先ポート | |
| well-known port | ウェルノウンポート | |
| socket | ソケット | |
| congestion / congestion window | 輻輳 / 輻輳ウィンドウ | 混雑 |
| round-trip time (RTT) | 往復時間（RTT） | ラウンドトリップ時間も既存訳に多い |
| packet loss | パケット損失 | パケットロス |
| loss | 損失 | 喪失、ロス |
| delay / latency | 遅延 | レイテンシー |
| jitter | ジッター | |
| throughput / bandwidth | スループット / 帯域幅 | 帯域（bandwidth の訳としては「帯域幅」を優先） |
| flow | フロー | |
| fragment / fragmentation | フラグメント / 断片化 | 断片、フラグメンテーション |
| path MTU | パスMTU | 経路MTU |
| keepalive | キープアライブ | |
| multipath | マルチパス | |
| middlebox / firewall | ミドルボックス / ファイアウォール | |
| best effort | ベストエフォート | |
| quality of service (QoS) | サービス品質（QoS） | |

## IP・ルーティング

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| IP address / IPv6 address | IPアドレス / IPv6アドレス | |
| source address / destination address | 送信元アドレス / 宛先アドレス | |
| unicast / multicast / anycast | ユニキャスト / マルチキャスト / エニーキャスト | |
| multicast group | マルチキャストグループ | |
| link-local | リンクローカル | |
| prefix / prefix length | プレフィックス / プレフィックス長 | |
| address family / address space | アドレスファミリー / アドレス空間 | |
| extension header | 拡張ヘッダー | |
| neighbor discovery | 近隣探索 | 近隣発見 |
| neighbor | 近隣 | ネイバー（隣接ルーターなどの adjacent は「隣接」） |
| adjacency | 隣接関係 | |
| router advertisement | ルーター広告 | |
| duplicate address detection | 重複アドレス検出 | |
| advertise / advertisement | 広告する / 広告 | アドバタイズ |
| route | 経路 | BGP などで経路情報の 1 エントリーを指す場合は「ルート」も多い |
| path | パス | 経路（文脈で使い分けている既存訳も多い） |
| next hop | ネクストホップ | 次ホップ |
| routing / routing protocol / routing table | ルーティング / ルーティングプロトコル / ルーティングテーブル | 経路表 |
| forward / forwarding | 転送する / 転送 | フォワーディング |
| autonomous system | 自律システム | |
| link state | リンクステート | リンク状態 |
| flooding | フラッディング | |
| area / border router | エリア / 境界ルーター | |
| control plane / data plane / management plane | コントロールプレーン / データプレーン / 管理プレーン | 制御プレーン |
| encapsulation / decapsulation | カプセル化 / カプセル化解除 | デカプセル化 |
| tunneling | トンネリング | |
| label switched path (LSP) | ラベルスイッチパス（LSP） | ラベルスイッチドパス |
| segment routing | セグメントルーティング | |
| traffic engineering | トラフィックエンジニアリング | |
| load balancing | 負荷分散 | ロードバランシング |
| provider edge (PE) | プロバイダーエッジ（PE） | |
| topology | トポロジー | |
| on-path / off-path | 経路上 / 経路外 | オンパス / オフパス |
| reachability | 到達可能性 | 到達性 |

## DNS

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| domain name / DNS name | ドメイン名 / DNS名 | |
| fully qualified domain name (FQDN) | 完全修飾ドメイン名（FQDN） | |
| host name | ホスト名 | |
| subdomain | サブドメイン | |
| resource record | リソースレコード | |
| name server | ネームサーバー | |
| resolver / stub resolver | リゾルバー / スタブリゾルバー | |
| zone | ゾーン | |
| delegation | 委任 | |
| authoritative | 権威 | 「権威サーバー」「権威ネームサーバー」のように使う |
| query | クエリー | 問い合わせ（古い RFC の既存訳に多い） |

## ネットワーク管理（SNMP・YANG・NETCONF）

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| network management | ネットワーク管理 | |
| Management Information Base (MIB) | 管理情報ベース（MIB） | |
| MIB module / MIB object | MIBモジュール / MIBオブジェクト | |
| managed object | 管理オブジェクト | 管理対象オブジェクト |
| object identifier (OID) | オブジェクト識別子（OID） | |
| agent / manager | エージェント / マネージャー | |
| notification originator | 通知発信者 | |
| command generator / command responder | コマンドジェネレーター / コマンドレスポンダー | |
| authoritative SNMP engine | 権威SNMPエンジン | |
| security model / access control model | セキュリティーモデル / アクセス制御モデル | |
| view-based | ビューベース | |
| data model / information model | データモデル / 情報モデル | |
| YANG module / YANG data model | YANGモジュール / YANGデータモデル | |
| data node / leaf / container / grouping | データノード / リーフ / コンテナー / グルーピング | YANG のステートメント名（augment など）は英語のまま |
| datastore | データストア | |
| schema | スキーマ | |
| tree diagram | ツリー図 | |
| operational state | 運用状態 | |
| access control / access control list | アクセス制御 / アクセス制御リスト | |

## メール・メディア・テキスト

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| email | 電子メール | 「メールアドレス」「メーリングリスト」など複合語では「メール」 |
| email address | メールアドレス | 電子メールアドレス |
| mailbox / envelope | メールボックス / エンベロープ | |
| body（メールの本文） | 本文 | 本体 |
| body part | ボディーパート | |
| attachment | 添付 | |
| relay | 中継する | リレー（MTA などを指す名詞の relay は「リレー」も多い） |
| media type / subtype | メディアタイプ / サブタイプ | MIMEタイプ |
| top-level media type | トップレベルメディアタイプ | |
| charset / character set | 文字セット | 文字集合 |
| character encoding | 文字エンコーディング | 文字符号化 |
| normalization / internationalization | 正規化 / 国際化 | |
| line break / newline | 改行 | |
| quote / quoted string | 引用符 / 引用符付き文字列 | クォート |
| delimiter | 区切り文字 | デリミタ |
| ABNF | ABNF | 初出は「拡張バッカス・ナウア記法（ABNF）」 |
| codec / payload format / payload type | コーデック / ペイロード形式 / ペイロードタイプ | ペイロードフォーマット |
| media stream | メディアストリーム | |
| coding（音声・映像の符号化） | 符号化 | コーディング |
| timestamp / time zone | タイムスタンプ / タイムゾーン | |
| leap second | うるう秒 | 閏秒 |
| display / rendering | 表示 / レンダリング | |

## 暗号・セキュリティー

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| security | セキュリティー | |
| privacy | プライバシー | |
| key（暗号鍵） | 鍵 | キー。暗号以外のキー（キャッシュキー、マップや辞書のキー、データベースのキー、JSON のキー）は「キー」 |
| public key / private key | 公開鍵 / 秘密鍵 | 公開キー、プライベートキー、秘密キー |
| symmetric key | 対称鍵 | 対称キー、共通鍵 |
| key pair | 鍵ペア | キーペア |
| key agreement | 鍵合意 | キー合意、鍵共有 |
| key exchange | 鍵交換 | |
| key management | 鍵管理 | |
| key type / key wrap | 鍵タイプ / 鍵ラップ | キータイプ、キーラップ |
| key identifier / key size / key length | 鍵識別子 / 鍵サイズ / 鍵長 | キー長 |
| content encryption key (CEK) | コンテンツ暗号化鍵 | コンテンツ暗号化キー |
| key derivation function (KDF) | 鍵導出関数 | |
| derive / derivation | 導出する / 導出 | 派生 |
| session key / signing key / encryption key | セッション鍵 / 署名鍵 / 暗号化鍵 | セッションキー |
| pre-shared key (PSK) | 事前共有鍵 | 事前共有キー |
| shared secret | 共有秘密 | 共有シークレット |
| secret | 秘密 | シークレット |
| keying material / key material | 鍵素材 | 鍵マテリアル、鍵材料 |
| signature / sign | 署名 / 署名する | |
| digital signature | デジタル署名 | |
| encrypt / encryption | 暗号化する / 暗号化 | |
| decrypt / decryption | 復号する / 復号 | 復号化 |
| plaintext / ciphertext | 平文 / 暗号文 | プレーンテキスト（暗号の文脈） |
| cipher suite | 暗号スイート | |
| authenticated encryption | 認証付き暗号 | |
| initialization vector (IV) | 初期化ベクトル | |
| nonce / salt | ノンス / ソルト | ナンス |
| random / random number | ランダム / 乱数 | |
| pseudorandom / pseudorandom function (PRF) | 疑似乱数 / 疑似ランダム関数 | 擬似乱数、擬似ランダム関数（既存訳では擬似のほうがやや多い） |
| entropy | エントロピー | |
| hash / digest / hash value | ハッシュ / ダイジェスト / ハッシュ値 | |
| hash function / hash algorithm | ハッシュ関数 / ハッシュアルゴリズム | |
| message digest | メッセージダイジェスト | |
| authentication tag | 認証タグ | |
| message authentication code (MAC) | メッセージ認証コード（MAC） | |
| curve / elliptic curve | 曲線 / 楕円曲線 | |
| algorithm identifier | アルゴリズム識別子 | アルゴリズムID |
| forward secrecy | 前方秘匿性 | フォワードシークレシー |
| certificate | 証明書 | |
| certificate authority / certification authority (CA) | 認証局（CA） | |
| trust anchor | トラストアンカー | 信頼アンカー |
| certificate chain / certification path | 証明書チェーン / 証明書パス | 認証パス |
| revocation / certificate revocation list | 失効 / 証明書失効リスト | 取り消し |
| self-signed | 自己署名 | |
| issuer / subject | 発行者 / サブジェクト | 主体 |
| distinguished name | 識別名 | |
| public key infrastructure (PKI) | 公開鍵基盤（PKI） | |
| authentication / authorization | 認証 / 認可 | |
| mutual authentication / client authentication | 相互認証 / クライアント認証 | |
| credential | クレデンシャル | 資格情報（既存訳でほぼ半々） |
| password | パスワード | |
| security association (SA) | セキュリティーアソシエーション（SA） | |
| security model / security policy / security level | セキュリティーモデル / セキュリティーポリシー / セキュリティーレベル | |
| attestation / verifier | アテステーション / 検証者 | ベリファイアー |
| integrity / confidentiality | 完全性 / 機密性 | 整合性、秘匿性 |
| integrity protection | 完全性保護 | |
| authenticity / non-repudiation | 真正性 / 否認防止 | |
| sensitive / sensitive information | 機密 / 機密情報 | 機微、センシティブ |
| trusted / untrusted | 信頼できる / 信頼できない | |
| attack / threat / vulnerability | 攻撃 / 脅威 / 脆弱性 | |
| threat model / attack vector | 脅威モデル / 攻撃ベクトル | |
| malicious | 悪意のある | 悪意ある |
| mitigate / mitigation | 緩和する / 緩和策 | 軽減 |
| countermeasure | 対策 | |
| compromise | 侵害 | 危殆化 |
| leak / disclosure | 漏洩 / 開示 | 漏えい |
| eavesdrop | 盗聴する | |
| spoof / impersonate | なりすます | 偽装、スプーフィング |
| brute force | 総当たり | ブルートフォース |
| denial of service (DoS) | サービス拒否（DoS） | |
| amplification | 増幅 | |
| downgrade | ダウングレード | |
| side channel / timing attack | サイドチャネル / タイミング攻撃 | |
| replay attack | リプレイ攻撃 | |
| man-in-the-middle attack | 中間者攻撃 | |
| on-path attacker | 経路上の攻撃者 | オンパス攻撃者 |
| request forgery | リクエストフォージェリー | |
| fingerprint / tracking / correlation | フィンガープリント / 追跡 / 相関 | 指紋、トラッキング |
| anonymity / pseudonym / consent | 匿名性 / 仮名 / 同意 | |

## データ形式（JSON・CBOR・CDDL・ASN.1・Structured Fields）

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| octet / byte / bit | オクテット / バイト / ビット | |
| string / byte string / byte sequence | 文字列 / バイト文字列 / バイト列 | |
| octet string / text string | オクテット文字列 / テキスト文字列 | |
| empty string | 空文字列 | 空の文字列 |
| character | 文字 | |
| integer / decimal / boolean | 整数 / 小数 / 真偽値 | ブール値。decimal が 10 進数表記を指す場合は「10進数」 |
| unsigned integer / signed integer | 符号なし整数 / 符号付き整数 | |
| hexadecimal / decimal（記数法） | 16進数 / 10進数 | |
| most significant bit / least significant bit | 最上位ビット / 最下位ビット | |
| network byte order / big-endian | ネットワークバイトオーダー / ビッグエンディアン | ネットワークバイト順 |
| array / map / object / member | 配列 / マップ / オブジェクト / メンバー | |
| element / attribute | 要素 / 属性 | |
| field / flag | フィールド / フラグ | フィールド名は英語のまま（Length フィールドなど） |
| TLV / sub-TLV | TLV / サブTLV | |
| tag | タグ | |
| identifier | 識別子 | |
| token | トークン | |
| parameter | パラメーター | パラメータ |
| value | 値 | |
| entry | エントリー | エントリ |
| list / inner list | リスト / インナーリスト | 内部リスト |
| dictionary | 辞書 | |
| item / bare item | アイテム / 裸のアイテム | 一般的な「項目」は可 |
| data type / type | データ型 / 型 | データタイプ。メディアタイプ、フレームタイプなど複合語では「タイプ」 |
| literal | リテラル | |
| namespace | 名前空間 | ネームスペース |
| binary | バイナリー | バイナリ |
| encoding / encode / decode | エンコーディング / エンコードする / デコードする | 符号化（暗号の文脈の decode は「復号」ではない） |
| encoding rules（ASN.1） | 符号化規則 | 例: 識別符号化規則（DER） |
| deterministic encoding | 決定論的エンコーディング | |
| serialization | シリアル化 | シリアライゼーション、直列化 |
| parse / parser | 解析する（パースする）/ パーサー | パーサ |
| whitespace | 空白 | ホワイトスペース |
| escape | エスケープ | |
| normalization | 正規化 | |
| media type | メディアタイプ | |
| memory | メモリー | メモリ |
| library | ライブラリー | ライブラリ |

## IANA・登録

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| registry / registration | レジストリー / 登録 | |
| registry group / subregistry | レジストリーグループ / サブレジストリー | |
| register | 登録する | |
| registration procedure / registration policy | 登録手続き / 登録ポリシー | 登録手順 |
| registration request | 登録リクエスト | 登録要求 |
| permanent / provisional (ステータス) | 英語のまま | |
| Specification Required, Standards Action, Expert Review, IETF Review, First Come First Served, IESG Approval | 英語のまま | 「仕様が必要」「標準化アクション」「専門家レビュー」などの訳は既存訳に少数 |
| designated expert / expert reviewer | 指定専門家 / 専門家レビュアー | |
| Private Use / Experimental Use | 英語のまま | プライベート使用、実験的使用 |
| reserved | 予約済み | 「予約されています」も可 |
| reserved for future use | 将来の使用のために予約 | |
| unassigned | 未割り当て | 未割当 |
| assign / allocate | 割り当てる | |
| code point | コードポイント | |
| initial contents | 初期内容 | |
| contact | 連絡先 | |
| this document (レジストリーの Reference 欄) | 英語のまま | 本文中の「this document」は「この文書」 |
| N/A | 該当なし | 不適用 |

## NFS（RFC 8881）

| 英語 | 訳語 | 避ける表記・備考 |
|---|---|---|
| filehandle / current filehandle / saved filehandle | ファイルハンドル / 現在のファイルハンドル / 保存されたファイルハンドル | |
| stateid | 英語のまま | 「オープンstateid」「レイアウトstateid」のように使う |
| client ID / client owner / server owner | クライアントID / クライアントオーナー / サーバーオーナー | |
| server scope | サーバースコープ | |
| open-owner / lock-owner / state-owner | 英語のまま | |
| session / slot / sequence ID | セッション / スロット / シーケンスID | |
| reply cache | リプライキャッシュ | 応答キャッシュ |
| requester / replier | リクエスター / リプライアー | |
| fore channel / backchannel | フォアチャネル / バックチャネル | |
| exactly once semantics (EOS) | 厳密に1回のセマンティクス（EOS） | |
| put filehandle operation | ファイルハンドル設定操作 | |
| delegation / recall / revoke | 委任 / リコール / 取り消す | |
| lease / grace period | リース / 猶予期間 | |
| reclaim | 再取得 | |
| share reservation | 共有予約 | |
| byte-range lock | バイト範囲ロック | |
| mandatory / advisory lock | 強制 / 助言的なロック | |
| named attribute / named attribute directory | 名前付き属性 / 名前付き属性ディレクトリー | |
| REQUIRED / RECOMMENDED attributes | 「<bcp14>要求されています（REQUIRED）</bcp14>」属性 / 「<bcp14>推奨されます（RECOMMENDED）</bcp14>」属性 | lint が形容詞形を許さないため、この書き方にする |
| trunking / trunking detection / trunking discovery | トランキング / トランキング検出 / トランキング発見 | |
| server-trunkable / session-trunkable | サーバートランキング可能 / セッショントランキング可能 | |
| referral / replica / replication / migration | リファラル / レプリカ / 複製 / 移行 | |
| Transparent State Migration | 透過的な状態移行 | |
| file system location / location entry / fs name | ファイルシステムの場所 / ファイルシステムの場所のエントリー / fs名 | |
| absent / present file system | 不在の / 存在するファイルシステム | |
| file system transition | ファイルシステムの遷移 | |
| transition recovery / migration recovery / migration discovery | 遷移回復 / 移行回復 / 移行発見 | |
| source / destination server | 移行元 / 移行先サーバー | |
| layout / layout type / iomode | レイアウト / レイアウトタイプ / iomode | |
| metadata server / data server / storage device | メタデータサーバー / データサーバー / ストレージデバイス | |
| storage protocol / control protocol | ストレージプロトコル / 制御プロトコル | |
| stripe / stripe unit / striping pattern | ストライプ / ストライプユニット / ストライピングパターン | |
| sparse / dense packing | スパース / デンスパッキング | |
| fencing / fence | フェンシング / フェンスする | |
| forgetful model | 忘却モデル | |
| want (delegation want) | 要望 | |
| stable storage | 安定ストレージ | |
| write verifier | 書き込みベリファイアー | |
| incarnation | インカーネーション | |
| personality（データサーバーの人格） | 人格 | |
| ARGUMENTS / RESULTS / DESCRIPTION / IMPLEMENTATION / ERRORS（操作の小見出し） | 引数 / 結果 / 説明 / 実装 / エラー | |
| Operation N: NAME - Title | 操作N：NAME - 訳した題名 | 例: 操作3：ACCESS - アクセス権のチェック |
| NAME (Error Code N) | NAME（エラーコードN） | |

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
| grant / authorization code | グラント / 認可コード | |
| claim | クレーム | 一般的な「主張する」は可 |
| assertion | アサーション | 表明 |
| issuer | 発行者 | |
| principal | プリンシパル | |
| header parameter | ヘッダーパラメーター | |
| compact serialization | コンパクトシリアル化 | コンパクトシリアライゼーション |
| JSON Web Token | JSON Web Token（JWT） | 英語のまま |

## 既存訳の揺れ

既存訳で訳語がそろっていなかったもののうち、機械的に検出できる表記は textlint の辞書に追加してあります。
次の語は既存訳でも揺れが大きいので、新しく訳すときは上の表の訳語にそろえてください。

- pseudo-（疑似 / 擬似）、credential（クレデンシャル / 資格情報）は既存訳でほぼ半々です。
- request / response、connection、component は、古い RFC（RFC 2xxx）の既存訳では「要求」「応答」「接続」「構成要素」が多数派ですが、全体では「リクエスト」「レスポンス」「コネクション」「コンポーネント」が多数派です。
- route / path（経路 / ルート / パス）は文脈で訳し分けている既存訳が多く、機械的にはそろえられません。

暗号の key（鍵／キー）のように文脈で訳し分ける語は lint で検出できないので、上の表に従って訳してください。
