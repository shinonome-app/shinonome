import { LitElement, css, html, unsafeCSS } from "lit";
import { customElement } from "lit/decorators.js";
import globalStyles from "../input.css?inline";

@customElement("snm-hiragana-index")
export class SnmHiraganaIndex extends LitElement {
  render() {
    return html`
      <table class="flex gap-3">
        <tbody>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="あ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="い" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="う" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="え" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="お" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="か" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="き" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="く" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="け" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="こ" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="さ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="し" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="す" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="せ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="そ" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="た" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ち" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="つ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="て" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="と" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="な" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="に" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ぬ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ね" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="の" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
        </tbody>

        <tbody>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="は" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ひ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ふ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="へ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ほ" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="ま" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="み" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="む" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="め" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="も" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="や" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ゆ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="よ" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="ら" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="り" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="る" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="れ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ろ" name="work" type="submit"></snm-input-hiragana></td>
          </tr>
          <tr class="flex gap-1">
            <td><snm-input-hiragana label="わ" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="を" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label="ん" name="work" type="submit"></snm-input-hiragana></td>
            <td><snm-input-hiragana label=" その他  " name="work" type="submit"></snm-input-hiragana></td>
          </tr>
        </tbody>
      </table>
    `;
  }

  static styles = [unsafeCSS(globalStyles), css``];
}

declare global {
  interface HTMLElementTagNameMap {
    "snm-hiragana-index": SnmHiraganaIndex;
  }
}
