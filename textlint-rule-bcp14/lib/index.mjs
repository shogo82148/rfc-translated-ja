// LICENSE : MIT
"use strict";
import { RuleHelper } from "textlint-rule-helper";
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
        case "選択できます（OPTIONAL）":
        case "必要があります（MUST）":
        case "しなければならない（MUST）":
        case "なりません（MUST NOT）":
        case "べきです（SHOULD）":
          return;
      }
      report(node, new RuleError(`Invalid BCP 14 key word: '${text}'`, {}));
    },
  };
}
