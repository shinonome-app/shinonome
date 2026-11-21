// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

// data-auto-submit を付けた入力欄は、値を変えたらそのフォームを送信する
// （CSP の script-src でインラインのイベントハンドラを使えないため）
document.addEventListener("change", (event) => {
  const field = event.target.closest("[data-auto-submit]")
  if (field && field.form) field.form.requestSubmit()
})
