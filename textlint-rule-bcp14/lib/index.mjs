// LICENSE : MIT
"use strict";
import { RuleHelper } from "textlint-rule-helper";

const ENGLISH_KEYWORDS = new Set([
  "MUST",
  "MUST NOT",
  "REQUIRED",
  "SHALL",
  "SHALL NOT",
  "SHOULD",
  "SHOULD NOT",
  "RECOMMENDED",
  "NOT RECOMMENDED",
  "MAY",
  "OPTIONAL",
]);

// pairs of opening and closing quotes that mark a mention of a key word
const QUOTES = [
  ["「", "」"],
  ["“", "”"],
  ["&quot;", "&quot;"],
  ['"', '"'],
];

/**
 * Reports whether the <bcp14> element around range is enclosed in quotes.
 * @param {string} source whole source text
 * @param {[number, number]} range range of the text inside the element
 */
function isQuoted(source, range) {
  const before = source.slice(0, range[0]).replace(/<bcp14[^>]*>$/, "");
  const after = source.slice(range[1]).replace(/^<\/bcp14>/, "");
  return QUOTES.some(
    ([open, close]) => before.endsWith(open) && after.startsWith(close),
  );
}
/**
 * @param {RuleContext} context
 */
export default function (context) {
  const helper = new RuleHelper(context);
  const { Syntax, getSource, RuleError, report } = context;
  return {
    /*
        Match pattern

            # Header
            TODO: quick fix this.
            ^^^^^
            Hit!
        */
    [Syntax.Str](node) {
      if (
        helper.isChildNode(node, [Syntax.Link, Syntax.Image, Syntax.BlockQuote])
      ) {
        return;
      }
      const parents = helper.getParents(node);
      const isBCP14 = parents.some((parent) => {
        return (
          parent.properties &&
          parent.properties.className &&
          parent.properties.className.includes("bcp14")
        );
      });
      if (!isBCP14) {
        return;
      }

      // get text from node
      const text = getSource(node);
      switch (text) {
        case "しなければなりません（MUST）":
        case "してはなりません（MUST NOT）":
        case "要求されています（REQUIRED）":
        case "することになります（SHALL）":
        case "することはありません（SHALL NOT）":
        case "すべきです（SHOULD）":
        case "すべきではありません（SHOULD NOT）":
        case "推奨されます（RECOMMENDED）":
        case "推奨されません（NOT RECOMMENDED）":
        case "してもよいです（MAY）":
        case "場合があります（MAY）":
        case "よいです（MAY）":
        case "選択できます（OPTIONAL）":
        case "必要があります（MUST）":
        case "必要がある（MUST）":
        case "しなければならない（MUST）":
        case "なければなりません（MUST）":
        case "なりません（MUST NOT）":
        case "べきです（SHOULD）":
        case "べきではありません（SHOULD NOT）":
        case "選択可能な（OPTIONAL）":
          return;
      }

      // Allow a bare English key word when the text mentions the word itself
      // rather than stating a requirement, e.g. 「<bcp14>SHOULD</bcp14>」.
      if (ENGLISH_KEYWORDS.has(text) && isQuoted(getSource(), node.range)) {
        return;
      }
      report(node, new RuleError(`Invalid BCP 14 key word: '${text}'`, {}));
    },
  };
}
