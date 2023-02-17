import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

type ButtonStyle = "primary" | "secondary" | "alert" | "normal";

type ButtonType = "link" | "input" | "submit";

@customElement("snm-button")
export class SnmButton extends LitElement {
  @property()
  label?: string = "label";

  @property()
  buttonStyle?: ButtonStyle = "primary";

  @property()
  buttonType?: ButtonType = "input";

  @property()
  name?: string = "";

  render() {
    let styleClasses = "";

    switch (this.buttonStyle) {
      case "primary":
        styleClasses =
          "grid w-full bg-ab_primary border-2 border-white hover:bg-ab_primary_hover hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#ebf8ff] active:bg-ab_primary_hover focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
      case "secondary":
        styleClasses =
          "grid w-full bg-white border-2 border-gray hover:bg-white hover:border-2 hover:border-gray hover:shadow-[0px_2px_18px_0px_#edf2f7] active:bg-white focus-visible:ring ring-gray-300 text-zinc-700 text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
      case "alert":
        styleClasses =
          "grid w-full bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
    }

    return html`
      <input
        type="${this.buttonType === "input" ? "input" : "submit"}"
        name=${this.name}
        value=${this.label}
        class="${styleClasses}"
      />
    `;
  }

  static styles = [
    unsafeCSS(globalStyles),
    css`
      @media screen and (max-width: 900px) {
        .small-screen-hidden {
          font-size: 0;
        }
      }
    `,
  ];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-button": SnmButton;
  }
}
