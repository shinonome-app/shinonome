import { LitElement, HTMLTemplateResult, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-table-vertical")
export class SnmTableVertical extends LitElement {

  @property()
  href: String = "";

  getTableElements(isHead: boolean) {
    const selector = isHead
      ? "snm-table-vertical-head > snm-table-vertical-tr"
      : "snm-table-vertical-body > snm-table-vertical-tr";
    const rows = this?.shadowRoot?.host?.querySelectorAll(selector);
    const trList: HTMLTemplateResult[] = [];

    rows?.forEach((row) => {
      const tds = row.querySelectorAll("snm-table-vertical-th, snm-table-vertical-td");
      const tdList: HTMLTemplateResult[] = [];

      tds?.forEach((col) => {
        if (col.nodeName === "SNM-TABLE-VERTICAL-TH") {
          tdList.push(html`<th class="pl-5 w-[20%] whitespace-nowrap">${col.textContent}</th>`);
        } else {
          const children: ChildNode[] = [];
          col.childNodes.forEach((node) => {
          children.push(node);
        });
          tdList.push(html`<td class="py-2.5 px-5">${children}</td>`);
        }
      });

      // prettier-ignore
      trList.push(html`<tr class="h-10 odd:bg-[#f8fafc]">${tdList}</tr>`);
    });

    // prettier-ignore
    return html`<tbody>${trList}</tbody>`;
  }

  getTableBody() {
    return this.getTableElements(false);
  }

  removeTemplate() {
    const snmBody = this?.shadowRoot?.host?.querySelector("snm-table-vertical-body");

    if (snmBody) {
      this?.shadowRoot?.host?.removeChild(snmBody);
    }
  }

  render() {
    const tableBody = this.getTableBody();

    this.removeTemplate();

    return html`
      <table class="w-full text-left text-sm lg:text-base border borger-ab_gray">
        ${tableBody}
      </table>
    `;
  }

  static styles = [unsafeCSS(globalStyles),
    css`
      tbody a {
        text-decoration: underline;
      }
    `,];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-table-vertical": SnmTableVertical;
  }
}
