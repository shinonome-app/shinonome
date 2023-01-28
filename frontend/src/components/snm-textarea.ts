import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-textarea")
export class SnmTextarea extends LitElement {
  @property()
  label?: string = "labelname";

  @property()
  for?: string = "";

  @property()
  name?: string = "inputname";

  @property()
  textareaId?: string = "textareaId";

  @property()
  errormessage?: string = "";

  render() {
    return html`
      <div class="mb-2">
        <label for="${this.for}" class="inline-block text-sm">${this.label}</label><br />
        <textarea
          name="${this.name}"
          id="${this.textareaId}"
          class="w-full border-2 border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] invalid:border-pink-500 invalid:text-pink-600 rounded outline-none transition duration-100 px-2 py-2"
        ></textarea>
        <div class="text-xs text-red-500 ${this.errormessage ? "" : "hidden"} required:block">${this.errormessage}</div>
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-textarea": SnmTextarea;
  }
}
