const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require("tailwindcss/plugin");

const fs = require("node:fs");
const svg2DataUri = (path) => {
  svg = fs.readFileSync(`./frontend/assets/svg/${path}`, "utf-8");
  return `url('data:image/svg+xml,${encodeURIComponent(svg)}')`;
};

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/assets/stylesheets/*.css',
    './app/views/**/*.html.erb',
    './app/components/**/*.{html.erb,rb}',
    './app/lib/pagy/*.rb',
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
      content: {
        homeIcon: svg2DataUri("home.svg"),
        noticeIcon: svg2DataUri("notice.svg"),
        userIcon: svg2DataUri("user.svg"),
        workIcon: svg2DataUri("work.svg"),
        personIcon: svg2DataUri("person.svg"),
        workerIcon: svg2DataUri("worker.svg"),
        websiteIcon: svg2DataUri("website.svg"),
        dbIcon: svg2DataUri("db.svg"),
        fileIcon: svg2DataUri("file.svg"),
        mailIcon: svg2DataUri("mail.svg"),
        penIcon: svg2DataUri("pen.svg"),
        commandIcon: svg2DataUri("command.svg"),
        rollerIcon: svg2DataUri("roller.svg"),
        adminIcon: svg2DataUri("admin.svg"),
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    plugin(function ({ addUtilities }) {
      const newUtilities = {
        ".bg-dropdownIcon": {
          "background-image": svg2DataUri("dropdown.svg"),
        },
      };
      addUtilities(newUtilities);
    }),
  ],
}
