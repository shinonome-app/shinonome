import { LitElement, unsafeCSS } from "lit";
import { html, literal } from "lit/static-html.js";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

type HType = "h1" | "h2" | "h3";

@customElement("snm-headline")
export class SnmHeadline extends LitElement {
  @property()
  h: HType = "h1";

  render() {
    const headlineTable = {
      h1: literal`h1`,
      h2: literal`h2`,
      h3: literal`h3`,
    };
    const styleClassesTable = {
      h1: "w-full text-2xl mb-5 p-3 inline-block font-bold bg-ab_bg_gray border-l-4 border-solid border-ab_navy",
      h2: "w-full text-xl mb-2 py-1 px-2 font-bold bg-transparent border-l-4 border-solid border-ab_navy",
      h3: "text-lg mt-5 mb-2 font-bold",
    };

    const headline = headlineTable[this.h] ?? literal`h1`;
    const styleClasses = styleClassesTable[this.h] ?? "";

    return html`<${headline} class="${styleClasses}"><slot></slot></${headline}>`;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-headline": SnmHeadline;
  }
}
