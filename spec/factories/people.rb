FactoryBot.define do
  factory :person do
    last_name { "MyText" }
    last_name_kana { "MyText" }
    last_name_en { "MyText" }
    first_name { "MyText" }
    first_name_kana { "MyText" }
    first_name_en { "MyText" }
    born_on { "2021-04-29" }
    died_on { "2021-04-29" }
    copyright_flag { false }
    email { "MyText" }
    url { "MyText" }
    description { "MyText" }
    note_user_id { 1 }
    basename { "MyText" }
    note { "MyText" }
    updated_by { "MyText" }
    sortkey { "MyText" }
    sortkey2 { "MyText" }
    input_count { 1 }
    publish_count { 1 }
  end
end
