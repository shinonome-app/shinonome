import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-checkbox")
export class SnmCheckbox extends LitElement {
  @property()
  label?: string = "label";

  @property()
  name?: string = "name";

  @property()
  value?: string = "value";

  @property()
  for?: string = "";

  @property()
  inputID?: string = "";


  render() {
    return html`
      <div class="mb-2">
        <input type="checkbox" name="${this.name}" id="${this.inputID}" value="${this.value}" />
        <label for="${this.for}" class="text-sm">${this.label}</label>
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-checkbox": SnmCheckbox;
  }
}
