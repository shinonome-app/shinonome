import { LitElement, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-logo")
export class SnmLogo extends LitElement {
  @property()
  href: String = "";

  @property()
  src: String = "";

  @property()
  label: String = "";

  render() {
    return html`
      <div>
        <a href="${this.href}" class="inline-flex items-center text-black-800 text-lg font-bold gap-2.5">
          <img src="${this.src}" /><span class="hidden sm:block">${this.label}</span>
        </a>
      </div>
    `;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-logo": SnmLogo;
  }
}
