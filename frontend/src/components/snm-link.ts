import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

type ButtonStyle = "primary" | "secondary" | "alert" | "normal";

type FontColor = "nav" | "sidebar";

type Icon =
  | "home"
  | "notice"
  | "user"
  | "down-arrow"
  | "work"
  | "person"
  | "worker"
  | "website"
  | "db"
  | "file"
  | "mail"
  | "pen"
  | "command"
  | "roller"
  | "admin"
  | "";

@customElement("snm-link")
export class SnmLink extends LitElement {
  @property()
  label?: string;

  @property()
  buttonStyle?: ButtonStyle = "primary";

  @property()
  fontColor?: FontColor = "sidebar";

  @property()
  href?: string = "";

  @property()
  icon?: Icon = "";

  @property()
  name?: string = "";

  @property()
  target?: string = "";

  render() {
    let styleClasses = "";
    let iconName = "";
    let fontStyle = "";

    switch (this.icon) {
      case "home":
        iconName = "before:content-homeIcon";
        break;
      case "notice":
        iconName = "before:content-noticeIcon";
        break;
      case "user":
        iconName = "before:content-userIcon";
        break;
      case "work":
        iconName = "before:content-workIcon";
        break;
      case "person":
        iconName = "before:content-personIcon";
        break;
      case "worker":
        iconName = "before:content-workerIcon";
        break;
      case "website":
        iconName = "before:content-websiteIcon";
        break;
      case "db":
        iconName = "before:content-dbIcon";
        break;
      case "file":
        iconName = "before:content-fileIcon";
        break;
      case "mail":
        iconName = "before:content-mailIcon";
        break;
      case "pen":
        iconName = "before:content-penIcon";
        break;
      case "command":
        iconName = "before:content-commandIcon";
        break;
      case "roller":
        iconName = "before:content-rollerIcon";
        break;
      case "admin":
        iconName = "before:content-adminIcon";
        break;
    }

    switch (this.fontColor) {
      case "nav":
        fontStyle = "text-ab_font_black hover:text-blue-800 text-xs small-screen-hidden";
        break;
      case "sidebar":
        fontStyle = "whitespace-nowrap text-white hover:text-ab_font_black text-sm hover:bg-[#95A1CB] px-2 py-3 rounded-md";
        break;
    }

    switch (this.buttonStyle) {
      case "primary":
        styleClasses =
          "grid w-full bg-ab_primary border-2 border-white hover:bg-ab_primary_hover hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#ebf8ff] active:bg-ab_primary_hover focus-visible:ring ring-gray-300 text-white text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
      case "secondary":
        styleClasses =
          "grid w-full bg-white border-2 border-gray hover:bg-white hover:border-2 hover:border-gray hover:shadow-[0px_2px_18px_0px_#edf2f7] active:bg-white focus-visible:ring ring-gray-300 text-zinc-700 text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
      case "alert":
        styleClasses =
          "grid w-full bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer";
        break;
      case "normal":
        styleClasses = `${iconName} ${fontStyle} w-full inline-block w-full before:mr-2 before:mt-2`;
        break;
    }

    if (this.label) {
      return html` <a href="${this.href}" target=${this.target} class="${styleClasses}">${this.label}</a> `;
    } else {
      return html` <a href="${this.href}" target=${this.target} class="${styleClasses}"><slot></slot></a> `;
    }
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
    "snm-link": SnmLink;
  }
}
