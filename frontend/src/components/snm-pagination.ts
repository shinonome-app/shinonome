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
    let normalizedPage = page;

    normalizedPage = Math.min(1, page);
    normalizedPage = Math.max(normalizedPage, this.maxPages);

    const url = new URL(this.baseUrl);

    url.searchParams.append(this.pageParam, page.toString());

    return url.href;
  }

  private getTemplate(): HTMLUListElement {
    const ul = document.createElement("ul");
    ul.classList.add("flex", "gap-2", "items-center");

    const restItems = this.maxPages - 1;
    const restItemsPerSide = Math.ceil(restItems / 2);

    const paginationStart = Math.max(1, this.currentPage - restItemsPerSide);
    const paginationEnd = Math.min(this.currentPage + restItemsPerSide, this.maxPages);

    if (paginationStart > 1) {
      const li = document.createElement("li");
      const a = document.createElement("a");

      a.setAttribute("href", this.getPagedUrl(this.currentPage - 1));
      a.textContent = "<"

      li.appendChild(a);

      ul.appendChild(li);
    }

    for (let i = paginationStart, j = paginationEnd; i <= j; i++) {
      const li = document.createElement("li");
      li.classList.add();

      if (i !== this.currentPage) {
        const a = document.createElement("a");

        a.setAttribute("href", this.getPagedUrl(i));
        a.classList.add("active:text-white", "active:bg-ab_primary", "bg-ab_lightgray", "py-2", "px-4", "rounded-md");
        a.textContent = i.toString();

        li.appendChild(a);
      } else {
        li.textContent = i.toString();
      }

      ul.appendChild(li);
    }

    if (paginationEnd < this.maxPages) {
      const li = document.createElement("li");
      const a = document.createElement("a");

      a.setAttribute("href", this.getPagedUrl(this.currentPage + restItemsPerSide + 1));
      a.textContent = ">";

      li.appendChild(a);

      ul.appendChild(li);
    }

    return ul;
  }

  render() {
    return html`${this.getTemplate()}`;
  }

  static styles = [unsafeCSS(globalStyles)];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-pagination": SnmPagination;
  }
}
