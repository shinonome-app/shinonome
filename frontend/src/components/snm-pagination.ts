import { LitElement, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-pagination")
export class SnmPagination extends LitElement {
  @property()
  baseUrl: string = window.location.origin + window.location.pathname;

  @property()
  pageParam: string = "page";

  @property()
  itemsPerPage: number = 5;

  @property()
  currentPage: number = 1;

  @property()
  maxPages: number = this.itemsPerPage;

  constructor() {
    super();

    const url = new URL(window.location.href);
    const page = url.searchParams.get(this.pageParam);

    if (page) {
      this.currentPage = parseInt(page);
    }
  }

  private getPagedUrl(page: number): string {
    const url = new URL(this.baseUrl);

    url.searchParams.append(this.pageParam, page.toString());

    return url.href;
  }

  private getTemplate(): HTMLUListElement {
    const ul = document.createElement("ul");
    ul.classList.add("flex", "gap-2", "items-center");

    const restItems = this.maxPages;
    const restItemsPerSide = Math.ceil(restItems / 1);

    const paginationStart = Math.max(1, this.currentPage - restItemsPerSide);
    const paginationEnd = Math.min(this.currentPage + restItemsPerSide, this.maxPages);

    if (this.currentPage > 1) {
      const li = document.createElement("li");
      const a = document.createElement("a");

      a.setAttribute("href", this.getPagedUrl(this.currentPage - 1));
      a.textContent = "< 次へ";

      li.appendChild(a);

      ul.appendChild(li);
    }

    for (let i = paginationStart, j = paginationEnd; i <= j; i++) {
      const li = document.createElement("li");
      li.classList.add(
        "h-7",
        "w-8",
        "rounded",
        "text-sm",
        "overflow-hidden",
        "bg-ab_navy",
        "text-white",
        "flex",
        "wrap",
        "justify-center",
        "items-center"
      );

      if (i !== this.currentPage) {
        const a = document.createElement("a");

        a.setAttribute("href", this.getPagedUrl(i));
        a.classList.add("h-7", "w-8", "bg-ab_lightgray", "text-sm", "text-black", "flex", "wrap", "justify-center", "items-center");
        a.textContent = i.toString();

        li.appendChild(a);
      } else {
        li.textContent = i.toString();
      }

      ul.appendChild(li);
    }

    if (this.currentPage < this.maxPages) {
      const li = document.createElement("li");
      const a = document.createElement("a");

      a.setAttribute("href", this.getPagedUrl(this.currentPage + 1));
      a.textContent = "次へ >";

      li.appendChild(a);

      ul.appendChild(li);
    }

    return ul;
  }

  render() {
    return html`<nav>${this.getTemplate()}</nav>`;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-pagination": SnmPagination;
  }
}
