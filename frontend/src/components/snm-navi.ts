import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-navi")
export class SnmNavi extends LitElement {
  @property()
  href: String = "";

  @property()
  src: String = "";

  @property()
  label: String = "";

  render() {
    return html`
      <div class="flex gap-8">
        <snm-link label="青空文庫トップページ" href="#" buttonStyle="normal" fontColor="nav" icon="home"></snm-link>
        <snm-link label="作業着手連絡システム" href="#" buttonStyle="normal" fontColor="nav" icon="notice"></snm-link>
        <div id="menu-title" class="relative">
          <div class="flex items-baseline gap-2">
            <snm-link label="admin@example.com" href="#" buttonStyle="normal" fontColor="nav" icon="user"></snm-link>
            <svg
              class="max-[900px]:hidden"
              width="10"
              height="7"
              viewBox="0 0 10 7"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M4.86214 6.49977L0.619141 2.25677L2.03414 0.842773L4.86214 3.67177L7.69014 0.842773L9.10514 2.25677L4.86214 6.49977Z"
                fill="#051831"
              />
            </svg>
          </div>
          <!-- ホバーメニュー - start -->
          <div id="menu-open" class="menu-open absolute right-0 w-[163px] bg-white px-5 py-4 drop-shadow-md">
            <ul class="text-xs grid gap-5 cursor-pointer">
              <li><a href="/admin/user/edit.html">パスワード変更</a></li>
              <li><a href="/login.html">ログアウト</a></li>
            </ul>
          </div>
          <!-- ホバーメニュー - end -->
        </div>
      </div>
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
    "snm-navi": SnmNavi;
  }
}
