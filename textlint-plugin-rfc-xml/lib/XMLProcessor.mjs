import { parse } from "./xml-to-ast.mjs";
export default class XMLProcessor {
  constructor(config) {
    this.config = config;
    this.extensions = this.config.extensions ? this.config.extensions : [];
  }

  availableExtensions() {
    return [".xml"].concat(this.extensions);
  }

  processor(_ext) {
    return {
      preProcess(text, _filePath) {
        return parse(text);
      },
      postProcess(messages, filePath) {
        return {
          messages,
          filePath: filePath ? filePath : "<rfc>",
        };
      },
    };
  }
}
