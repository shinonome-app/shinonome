import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-header")
export class SnmHeader extends LitElement {

  render() {
    return html`
      <header class="bg-white shadow-sm fixed top-0 left-0 w-full z-50 transition ease-in duration-300">
        <div class="max-w-7xl mx-auto flex justify-between items-center py-2 px-4 md:px-8">
          <slot name="logo"></slot>
          <!-- ロゴ - end -->
          <!-- ナビゲーション - start -->
          <slot name="navi"></slot>
          <!-- ナビゲーション - end -->
        </div>
      </header>
    `;
  }

  static styles = [
    unsafeCSS(globalStyles),
    css`
      #menu-open {
        display: none;
      }
      #menu-title:hover #menu-open {
        display: block;
      }
    `,
  ];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-header": SnmHeader;
  }
}
