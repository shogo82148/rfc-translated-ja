# BCP14

基本的に[RFC 2119]の和訳をそのまま使います。

```xml
<bcp14>しなければなりません（MUST）</bcp14>
<bcp14>してはなりません（MUST NOT）</bcp14>
<bcp14>要求されています（REQUIRED）</bcp14>
<bcp14>することになります（SHALL）</bcp14>
<bcp14>することはありません（SHALL NOT）</bcp14>
<bcp14>すべきです（SHOULD）</bcp14>
<bcp14>すべきではありません（SHOULD NOT）</bcp14>
<bcp14>推奨されます（RECOMMENDED）</bcp14>
<bcp14>推奨されません（NOT RECOMMENDED）</bcp14>
<bcp14>してもよいです（MAY）</bcp14>
<bcp14>選択できます（OPTIONAL）</bcp14>
```

文脈によっては、[RFC 2119]の和訳そのままでは不自然な文章になってしまう場合があります。
必要に応じて以下の表現も使用します。

```xml
<bcp14>必要があります（MUST）</bcp14>
<bcp14>しなければならない（MUST）</bcp14>
<bcp14>なりません（MUST NOT）</bcp14>
<bcp14>べきです（SHOULD）</bcp14>
<bcp14>場合があります（MAY）</bcp14>
```

## 例

```xml
英語: When an AKP algorithm requires or encourages that a key be validated before being used, all algorithm-related key parameters <bcp14>MUST</bcp14> be validated.
日本語訳: AKP アルゴリズムが、使用前の鍵検証を要求または推奨する場合、アルゴリズム関連のすべての鍵パラメーターを検証<bcp14>しなければなりません（MUST）</bcp14>。
```

```xml
英語: The ctx parameter <bcp14>MUST</bcp14> be the empty string for ML-DSA-44, ML-DSA-65, and ML-DSA-87.
日本語訳: ctx パラメーターは、ML-DSA-44、ML-DSA-65、および ML-DSA-87 では空文字である<bcp14>必要があります（MUST）</bcp14>。
```

[RFC 2119]: https://shogo82148.github.io/rfc-translated-ja/rfc2119.html
