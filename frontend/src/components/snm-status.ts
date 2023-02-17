import { LitElement, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-status")
export class SnmStatus extends LitElement {
  @property()
  statusType: String = "green";

  @property()
  label: String = "";

  render() {
    let styleClasses = "";

    switch (this.statusType) {
      case "green":
        styleClasses = "bg-ab_lightgreen text-ab_green px-3 py-1 rounded-full";
        break;
      case "yellow":
        styleClasses = "bg-ab_lightyellow text-ab_yellow px-3 py-1 rounded-full";
        break;
      case "gray":
        styleClasses = "bg-ab_lightgray text-ab_gray px-3 py-1 rounded-full";
        break;
    }

    return html` <span class="${styleClasses}">${this.label}</span> `;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-status": SnmStatus;
  }
}
