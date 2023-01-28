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
  | "admin"
  | "";

@customElement("snm-link")
export class SnmLink extends LitElement {
  @property()
  label?: string = "label";

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

  render() {
    let styleClasses = "";
    let iconName = "";
    let fontStyle = "";

    switch (this.icon) {
      case "home":
        iconName = "before:content-[url('/home.svg')]";
        break;
      case "notice":
        iconName = "before:content-[url('/notice.svg')]";
        break;
      case "user":
        iconName = "before:content-[url('/user.svg')]";
        break;
      case "down-arrow":
        iconName = "after:content-[url('/dropdown.svg')]";
        break;
      case "work":
        iconName = "before:content-[url('/work.svg')]";
        break;
      case "person":
        iconName = "before:content-[url('/person.svg')]";
        break;
      case "worker":
        iconName = "before:content-[url('/worker.svg')]";
        break;
      case "website":
        iconName = "before:content-[url('/website.svg')]";
        break;
      case "db":
        iconName = "before:content-[url('/db.svg')]";
        break;
      case "file":
        iconName = "before:content-[url('/file.svg')]";
        break;
      case "mail":
        iconName = "before:content-[url('/mail.svg')]";
        break;
      case "pen":
        iconName = "before:content-[url('/pen.svg')]";
        break;
      case "command":
        iconName = "before:content-[url('/command.svg')]";
        break;
      case "admin":
        iconName = "before:content-[url('/admin.svg')]";
        break;
    }

    switch (this.fontColor) {
      case "nav":
        fontStyle = "text-ab_font_black hover:text-blue-800 text-xs small-screen-hidden";
        break;
      case "sidebar":
        fontStyle = "text-white hover:text-ab_font_black text-sm hover:bg-[#95A1CB] px-2 py-3 rounded-md";
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

    return html` <a href="${this.href}" class="${styleClasses}">${this.label}</a> `;
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
