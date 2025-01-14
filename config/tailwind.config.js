const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require("tailwindcss/plugin");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/assets/stylesheets/*.css',
    './app/views/**/*.html.erb',
    './app/components/**/*.{html.erb,rb}',
    './app/lib/pagy/*.rb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
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
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
    plugin(function ({ addUtilities }) {
      const newUtilities = {
        ".bg-dropdownIcon": {
          // URI.encode_uri_component(File.read('app/assets/icons/dropdown.svg'))
          "background-image": "url(data:image/svg+xml,%3Csvg%20width%3D%2212%22%20height%3D%226%22%20viewBox%3D%220%200%2014%208%22%20fill%3D%22none%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%0A%3Cpath%20d%3D%22M1%201L7%207L13%201%22%20stroke%3D%22%235E6366%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%0A%3C%2Fsvg%3E%0A)",
        },
      };
      addUtilities(newUtilities);
    }),
  ]
}
