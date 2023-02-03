import { LitElement, html, unsafeCSS } from "lit";
import { customElement } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-main-container")
export class SnmMainContainer extends LitElement {
  render() {
    return html`
      <div class="mt-24 max-w-7xl m-auto flex gap-5">

        <div class="w-[60%] sm:w-[40%] xl:w-[30%]">
          <snm-sidebar></snm-sidebar>
        </div>

        <div class="w-full flex flex-col">
          
          <snm-message-bar level="notice">ログインしました。</snm-message-bar>
          <snm-message-bar level="success">追加しました。</snm-message-bar>
          <snm-message-bar level="alert">更新できませんでした。</snm-message-bar>
          
          <div class="h-full bg-white p-5"><slot></slot></div>
        </div>

      </div>
    `;
  }
  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-main-container": SnmMainContainer;
  }
}
