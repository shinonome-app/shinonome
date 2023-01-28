import { LitElement, HTMLTemplateResult, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-table")
export class SnmTable extends LitElement {
  @property()
  href: String = "";

  getTableElements(isHead: boolean) {
    const selector = isHead ? "snm-table-head > snm-table-row" : "snm-table-body > snm-table-row";
    const rows = this?.shadowRoot?.host?.querySelectorAll(selector);
    const trList: HTMLTemplateResult[] = [];

    rows?.forEach((row) => {
      const columns = row.querySelectorAll("snm-table-col");
      const tdList: HTMLTemplateResult[] = [];

      columns?.forEach((col) => {
        const children: ChildNode[] = [];
        col.childNodes.forEach((node) => {
          children.push(node);
        });
        tdList.push(isHead ? html`<th class="whitespace-nowrap">${children}</th>` : html`<td class="text-center whitespace-nowrap py-3 px-5">${children}</td>`);
      }); 

      // prettier-ignore
      trList.push(html`<tr class="h-10 even:bg-[#f8fafc]">${tdList}</tr>`);
    });

    // prettier-ignore
    return isHead ? html`<thead class="text-center bg-[#f8fafc]">${trList}</thead>` : html`<tbody>${trList}</tbody>`;
  }

  getTableHead() {
    return this.getTableElements(true);
  }

  getTableBody() {
    return this.getTableElements(false);
  }

  removeTemplate() {
    const snmHead = this?.shadowRoot?.host?.querySelector("snm-table-head");
    const snmBody = this?.shadowRoot?.host?.querySelector("snm-table-body");

    if (snmHead) {
      this?.shadowRoot?.host?.removeChild(snmHead);
    }

    if (snmBody) {
      this?.shadowRoot?.host?.removeChild(snmBody);
    }
  }

  render() {
    const tableHead = this.getTableHead();
    const tableBody = this.getTableBody();

    this.removeTemplate();

    return html`
      <table class="table-auto w-full text-sm lg:text-base border borger-ab_gray">
        ${tableHead} ${tableBody}
      </table>
    `;
  }

  static styles = [
    unsafeCSS(globalStyles),
    css`
      tbody a {
        text-decoration: underline;
      }
    `,
  ];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-table": SnmTable;
  }
}
