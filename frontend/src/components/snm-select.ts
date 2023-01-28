import { LitElement, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-select")
export class SnmSelect extends LitElement {
  @property()
  label?: string = "";

  @property()
  name?: string = "inputname";

  @property()
  for?: string = "";

  @property()
  selectId?: string = "";

  @property()
  errormessage?: string = "";

  render() {
    const host = this?.shadowRoot?.host;
    const options = host?.querySelectorAll("option");

    return html`
      <div class="mb-2 flex flex-col">
        <label for="${this.for}" class="inline-block text-sm mb-1 ${this.label ? "" : "hidden"}">${this.label}</label>
          <select
            class="min-w-[200px] bg-[url('/dropdown.svg')] bg-no-repeat bg-[right_0.8rem_center] rounded px-2 py-2 border-2 border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] cursor-pointer appearance-none"
            name="${this.name}"
            id="${this.selectId}"
          >
            ${options}
          </select>
        <div class="text-xs text-red-500 ${this.errormessage ? "" : "hidden"} required:block">${this.errormessage}</div>
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-select": SnmSelect;
  }
}
