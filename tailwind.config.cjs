const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/assets/stylesheets/*.css',
    './app/views/**/*.html.erb',
    './app/components/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './frontend/**/*.{ts,js}'
  ],
  theme: {
    extend: {
      colors: {
        ab_navy: "#21234C", //濃いネイビー
        ab_bg_gray: "#FBFBFF", //薄いグレー（背景）
        ab_form: "#9fa2a4", //インプットフォームのボーダー グレー
        ab_focus: "#66A3FF", //インプット　フォーカス時　ブルー
        ab_primary: "#5555A1", //プライマリーボタン
        ab_primary_hover: "#4040B6", //プライマリーボタン ホバー時
        ab_alert: "#E16858", //アラートボタン
        ab_font_black: "#334155", //テキストブラック
        ab_green: "#097139", //グリーン
        ab_lightgreen: "#EBF9F1", //淡いグリーン
        ab_yellow: "#564E03", //イエロー
        ab_lightyellow: "#FFFAE9", //淡いイエロー
        ab_gray: "#6F6969", //グレー
        ab_lightgray: "#F4F4F4", //淡いグレー
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: []
}
