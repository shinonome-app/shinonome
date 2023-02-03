import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement, property } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-input-file")
export class SnmInputFile extends LitElement {
  @property()
  label?: string = "";

  @property()
  name?: string = "inputname";

  @property()
  inputId?: string = "inputId";

  @property()
  for?: string = "";

  @property({ type: String })
  fileName = "選択されていません";

  render() {
    return html`
      <div class="mb-2 flex flex-col">
        <label for="${this.for}" class="inline-block text-sm ${this.label ? "" : "hidden"}">${this.label}</label>
        <div>
          <label class="cursor-pointer border-2 border-ab_form bg-ab_lightgray px-5 py-3 rounded inline-block text-sm mb-1">
            <input
              name="${this.name}"
              type="file"
              id="${this.inputId}"
              class="w-full hidden"
              @change="${(event: Event) => this.onFileSelected(event)}"
            />ファイルを選択</label
          >
          <span class="text-xs ml-3">${this.fileName}</span>
        </div>
      </div>
    `;
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.fileName = input.files[0].name;
    }
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-input-file": SnmInputFile;
  }
}
