import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-input-hiragana")
export class SnmInputHiragana extends LitElement {
  @property()
  label?: string = "labelname";

  @property()
  name?: string = "inputname";

  @property()
  type?: string = "text";

  render() {
    return html`
      <div class="mb-2">
        <input
          name="${this.name}"
          type="${this.type}"
          value="${this.label}"
          class="w-full border-2 text-sm hover:bg-[#D9E8FF] border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] rounded outline-none transition duration-100 px-2 py-1 cursor-pointer"
        />
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-input-hiragana": SnmInputHiragana;
  }
}
