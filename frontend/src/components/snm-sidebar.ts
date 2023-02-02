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
          <snm-link href="/admin/works.html" buttonStyle="normal" icon="work">作品検索</snm-link>
          <snm-link href="/admin/people.html" buttonStyle="normal" icon="person">人物検索</snm-link>
          <snm-link href="/admin/workers.html" buttonStyle="normal" icon="worker">工作員検索</snm-link>
          <snm-link href="/admin/sites.html" buttonStyle="normal" icon="website">関連サイト検索</snm-link>
        </div>
        <hr class="border-slate-500 my-3" />
        <div>
          <span class="text-[#ABABAB] text-sm ml-2">登録</span>
          <snm-link href="/admin/works/new.html" buttonStyle="normal" icon="work">作品新規登録</snm-link>
          <snm-link href="/admin/people/new.html" buttonStyle="normal" icon="person">人物新規登録</snm-link>
          <snm-link href="/admin/workers/new.html" buttonStyle="normal" icon="worker">工作員新規登録</snm-link>
          <snm-link href="/admin/sites/new.html" buttonStyle="normal" icon="website">関連サイト新規登録</snm-link>
        </div>
        <hr class="border-slate-500 my-3" />
        <div>
          <span class="text-[#ABABAB] text-sm ml-2">その他</span>
          <snm-link href="/admin/receipts.html" buttonStyle="normal" icon="db">WEB入力受付処理</snm-link>
          <snm-link href="/admin/proofreads.html" buttonStyle="normal" icon="file">WEB校正受付処理</snm-link>
          <snm-link href="/admin/admin_mail_secrets/new.html" buttonStyle="normal" icon="mail">工作員メール送信</snm-link>
          <snm-link href="/admin/news_entries.html" buttonStyle="normal" icon="pen">そらもよう</snm-link>
          <snm-link href="/admin/exec_commands.html" buttonStyle="normal" icon="command">コマンド実行機能</snm-link>
          <snm-link href="/admin/user/others.html" buttonStyle="normal" icon="admin">管理者の追加・削除</snm-link>
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
