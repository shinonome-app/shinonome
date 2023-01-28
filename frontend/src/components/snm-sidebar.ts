import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-sidebar")
export class SnmSidebar extends LitElement {
  @property()
  render() {
    return html`
      <aside class="bg-ab_navy min-h-screen px-6 py-10 rounded-md">
        <div>
          <span class="text-[#ABABAB] text-sm ml-2">検索</span>
          <snm-link label="作品検索" href="../../admin/works.html" buttonStyle="normal" icon="work"></snm-link>
          <snm-link label="人物検索" href="../../admin/people.html" buttonStyle="normal" icon="person"></snm-link>
          <snm-link label="工作員検索" href="../../admin/workers.html" buttonStyle="normal" icon="worker"></snm-link>
          <snm-link label="関連サイト検索" href="../../admin/sites.html" buttonStyle="normal" icon="website"></snm-link>
        </div>
        <hr class="border-slate-500 my-3" />
        <div>
          <span class="text-[#ABABAB] text-sm ml-2">登録</span>
          <snm-link label="作品新規登録" href="../../admin/works/new.html" buttonStyle="normal" icon="work"></snm-link>
          <snm-link label="人物新規登録" href="../../admin/people/new.html" buttonStyle="normal" icon="person"></snm-link>
          <snm-link label="工作員新規登録" href="../../admin/workers/new.html" buttonStyle="normal" icon="worker"></snm-link>
          <snm-link label="関連サイト新規登録" href="../../admin/sites/new.html" buttonStyle="normal" icon="website"></snm-link>
        </div>
        <hr class="border-slate-500 my-3" />
        <div>
          <span class="text-[#ABABAB] text-sm ml-2">その他</span>
          <snm-link label="WEB入力受付処理" href="../../admin/receipts.html" buttonStyle="normal" icon="db"></snm-link>
          <snm-link label="WEB校正受付処理" href="../../admin/proofreads.html" buttonStyle="normal" icon="file"></snm-link>
          <snm-link label="工作員メール送信" href="../../admin/admin_mail_secrets/new.html" buttonStyle="normal" icon="mail"></snm-link>
          <snm-link label="そらもよう" href="../../admin/news_entries.html" buttonStyle="normal" icon="pen"></snm-link>
          <snm-link label="コマンド実行機能" href="../../admin/exec_commands.html" buttonStyle="normal" icon="command"></snm-link>
          <snm-link label="管理者の追加・削除" href="../../admin/user/others.html" buttonStyle="normal" icon="admin"></snm-link>
        </div>
      </aside>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-sidebar": SnmSidebar;
  }
}
