import { unified } from "unified";
import rehypeParse from "rehype-parse";
import { StructuredSource } from "structured-source";

const walk = (node, fn) => {
  if (!fn(node)) {
    return;
  }
  if (node.children) {
    for (const child of node.children) {
      walk(child, fn);
    }
  }
};

const location = (src, node) => {
  const position = node.position;
  const loc = {
    start: {
      line: position.start.line,
      column: position.start.column - 1,
    },
    end: {
      line: position.end.line,
      column: position.end.column - 1,
    },
  };
  const range = src.locationToRange(loc);
  return {
    loc: loc,
    range: range,
  };
};

export function parse(xml, options) {
  const parseXml = unified().use(rehypeParse);
  const ast = parseXml.parse(xml);
  const src = new StructuredSource(xml);

  const collect_text = (node) => {
    const children = [];
    walk(node, (child) => {
      if (child.type === "element" && child.tagName === "bcp14") {
        const { loc, range } = location(src, child);
        children.push({
          type: "Strong",
          children: collect_text({ children: child.children }),
          loc,
          range,
          raw: xml.slice(range[0], range[1]),
          properties: {
            className: ["bcp14"],
          },
        });
        return false;
      }
      if (child.type === "text") {
        const { loc, range } = location(src, child);
        children.push({
          type: "Str",
          value: child.value,
          loc,
          range,
          raw: xml.slice(range[0], range[1]),
        });
      }
      return true;
    });
    return children;
  };

  const children = [];
  walk(ast, function (node) {
    if (node.type === "element") {
      if (node.tagName === "t") {
        const { loc, range } = location(src, node);
        const paragraph = {
          type: "Paragraph",
          children: collect_text(node),
          loc,
          range,
          raw: xml.slice(range[0], range[1]),
        };
        children.push(paragraph);
        return false;
      } else if (node.tagName === "name") {
        const { loc, range } = location(src, node);
        const header = {
          type: "Header",
          children: collect_text(node),
          loc,
          range,
          raw: xml.slice(range[0], range[1]),
        };
        children.push(header);
        return false;
      }
    }
    return true;
  });

  const { loc, range } = location(src, ast);
  const ret = {
    type: "Document",
    children,
    loc,
    range,
    raw: xml,
  };
  return ret;
}
