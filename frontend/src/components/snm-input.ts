import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-input")
export class SnmInput extends LitElement {
  @property()
  label?: string = "";

  @property()
  name?: string = "inputname";

  @property()
  type?: string = "text";

  @property()
  inputId?: string = "inputId";

  @property()
  for?: string = "";

  @property()
  value?: string = "";

  @property()
  errormessage?: string = "";

  render() {
    return html`
      <div class="mb-2">
        <label for="${this.for}" class="inline-block text-sm ${this.label ? "" : "hidden"}">${this.label}</label>
        <input
          name="${this.name}"
          type="${this.type}"
          id="${this.inputId}"
          value="${this.value}"
          class="text-gray-600 w-full border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] invalid:border-pink-500 invalid:text-pink-600 rounded outline-none transition duration-100 px-2 py-2"
        />
        <div class="text-xs text-red-500 ${this.errormessage ? "" : "hidden"} required:block">${this.errormessage}</div>
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-input": SnmInput;
  }
}
