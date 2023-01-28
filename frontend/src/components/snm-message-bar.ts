import { LitElement, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "~/src/input.css?inline";

type ButtonStyle = "notice" | "success" | "alert" ;

@customElement("snm-message-bar")
export class SnmMessageBar extends LitElement {
 
  @property()
  buttonStyle: ButtonStyle = "notice";

  render() {
    let styleClasses = "";

    switch (this.buttonStyle) {
      case "notice":
        styleClasses =
          "text-[#022C45] bg-[#C3E9FF] text-xs px-8 py-3 rounded mb-2";
        break;
      case "success":
        styleClasses =
          "text-[#012B14] bg-[#BFF9D9] text-xs px-8 py-3 rounded mb-2";
        break;
      case "alert":
        styleClasses =
          "text-[#400601] bg-[#FECDC9] text-xs px-8 py-3 rounded mb-2";
        break;
    }

    return html`
      <div class="${styleClasses}">

        <svg class="inline mr-1 mb-1" width="15" height="15" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M1 0H17C17.2652 0 17.5196 0.105357 17.7071 0.292893C17.8946 0.48043 18 0.734784 18 1V17C18 17.2652 17.8946 17.5196 17.7071 17.7071C17.5196 17.8946 17.2652 18 17 18H1C0.734784 18 0.48043 17.8946 0.292893 17.7071C0.105357 17.5196 0 17.2652 0 17V1C0 0.734784 0.105357 0.48043 0.292893 0.292893C0.48043 0.105357 0.734784 0 1 0ZM2 2V16H16V2H2ZM8.003 13L3.76 8.757L5.174 7.343L8.003 10.172L13.659 4.515L15.074 5.929L8.003 13Z" fill="#022C45"/>
        </svg>

        <slot></slot>
      </div>
    `;
  }

  static styles = [
    unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-message-bar": SnmMessageBar;
  }
}
