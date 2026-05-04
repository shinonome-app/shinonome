# Rails view query ↔ Rust JSONL マッピング

`komadome` (Rails) の view component / controller が ActiveRecord で読み出している主要な
クエリ単位と、`komadome-rs` 側で同じ意味のデータがどの JSONL のどのフィールドにあるか、
および JSONL を生成する `commands/export/*.rs` の対応箇所をまとめる。

両者の挙動を同期させたい場面 (例: 新しい view 要素を追加する、SQL 条件を変える、ソート順を変える)
で参照する索引。Rust 側に「query 関数」を独立に持つわけではなく、JSONL 生成 (`commands/export/`) と
JSONL 利用 (`generator/builder/`) のペアが直接対応する。

## Work 系

| Rails view 側のクエリ意図 | Rust JSONL ソース | Rust 生成側 (`commands/export/`) | Rust 利用側 (`generator/builder/`) |
|---|---|---|---|
| 図書カード (work_id × person_id で 1 件) | `cards.jsonl` の 1 レコード | `cards.rs` | `card.rs` |
| top の最新公開作品リスト + 公開日 | `top.json` の `new_works`、`new_works_published_on` | `top.rs` | `top.rs` |
| top の公開作品総数 / 著作権あり・なしカウント | `top.json` の `works_count`、`works_copyright_count`、`works_noncopyright_count` | `top.rs` | `top.rs` |
| whatsnew 年別 (公開日降順) | `whatsnew.jsonl` の `entries` (年・ページ単位) | `whatsnew.rs` | `whatsnew.rs` |
| カナ別タイトル索引 (公開) | `work_indexes.jsonl` (kana_symbol × page) | `work_indexes.rs` | `work_index.rs` |
| カナ別タイトル索引 (非公開・作業中) | `wip_work_indexes.jsonl` | `wip_work_indexes.rs` | `wip_work_index.rs` |
| カードの著者・全 work_people・workfiles・work_workers・関連サイト | `cards.jsonl` 内の `authors`、`work_people_details`、`workfiles`、`work_workers`、`sites` (それぞれ事前ソート済) | `cards.rs` | `card.rs` |
| 人物別 公開作品リスト + 件数 | `person_pages.jsonl` の `works` | `person_pages.rs` | `person.rs` |
| 人物別 非公開作品リスト + 件数 | `person_pages.jsonl` の `unpublished_works` | `person_pages.rs` | `person.rs` |
| 人物別 list_inp 用 非公開作品 (ページ分割) | `list_inp.jsonl` | `list_inp.rs` | `list_inp.rs` |
| 人物総数表示用カウント (works.count / works.unpublished.count) | `person_all_indexes.jsonl` の `total_count`、`unpublished_count` | `person_all_indexes.rs` | `person_all_index.rs` |

## Person 系

| Rails view 側のクエリ意図 | Rust JSONL ソース | Rust 生成側 | Rust 利用側 |
|---|---|---|---|
| sortkey カナ先頭フィルタ (公開作品持ちの人物) | `person_indexes.jsonl` の sections (kana_char) | `person_indexes.rs` | `person_index.rs` |
| sortkey カナ先頭フィルタ (非公開作品持ちの人物) | `person_all_indexes.jsonl` を `unpublished_count > 0` で絞った相当 (実際は `wip_person_indexes.jsonl` も別途ある) | `person_all_indexes.rs` / `wip_person_indexes.rs` | `person_all_index.rs` / `wip_person_index.rs` |
| 人物詳細ページの関連サイト | `person_pages.jsonl` の `sites` | `person_pages.rs` | `person.rs` |

## NewsEntry 系

| Rails view 側のクエリ意図 | Rust JSONL ソース | Rust 生成側 | Rust 利用側 |
|---|---|---|---|
| top のトピック (直近 10 件) | `top.json` の `topics` | `top.rs` | `top.rs` |
| 最新ニュース公開日 | `top.json` の `latest_news_published_on` | `top.rs` | `top.rs` |
| 年別 そらもよう一覧 | `news.jsonl` の `entries` (year 単位) | `news.rs` | `soramoyou.rs` |

## 同期維持のための運用メモ

- Rails の view が呼ぶ AR のソート順 (`(:sortkey, :subtitle_kana, :id)` 等) は、
  Rust 側の `commands/export/*.rs` の SQL `ORDER BY` 句と一致している必要がある。
  どちらかを変える PR ではもう片方も同時に変える。
- カナ先頭判定の正規表現 `^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]` は
  Rails 側 (`PersonQueries::KANA_FIRSTCHAR_REGEX`、`Work` の scope) と
  Rust 側 (`generator/kana.rs` の `COLUMN_CHARS` / `is_kana_firstchar` 系ヘルパ) で重複している。
  将来 contracts/business_rules.* 等で言語非依存に持つことを検討。
- `role_id`、`work_status_id` の意味 (1=著者 / 2=翻訳者 / 16=原著者、1=公開 / 11=入力待ち 等) は
  両側で magic number として現れる。Rust 側 `data/masters.rs` と Rails 側 enum / 定数を同期する。
- 出力 HTML の同期は `scripts/compare_builds.rb` で byte-level 差分検査できる (Ruby/Rust 両方ビルド後に実行)。
