FactoryBot.define do
  factory :book do
    title { "MyText" }
    title_kana { "MyText" }
    subtitle { "MyText" }
    subtitle_kana { "MyText" }
    collection { "MyText" }
    collection_kana { "MyText" }
    orig_title { "MyText" }
    kana_type_id { 1 }
    author_display_name { "MyText" }
    first_appearance { "MyText" }
    description { "MyText" }
    description_person_id { 1 }
    status { "MyText" }
    started_on { "2021-04-29" }
    copyright_flag { false }
    note { "MyText" }
    orig_text { "MyText" }
    updated_at { "2021-04-29 20:43:01" }
    user_id { 1 }
    update_flag { 1 }
    sortkey { "MyText" }
  end
end
