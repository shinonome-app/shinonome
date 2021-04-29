FactoryBot.define do
  factory :proofread do
    book_id { 1 }
    book_copy { "MyText" }
    book_print { "MyText" }
    refbook { "MyText" }
    bookfile_id { 1 }
    address { "MyText" }
    memo { "MyText" }
    worker_id { 1 }
    woker_kana { "MyText" }
    worker_name { "MyText" }
    email { "MyText" }
    url { "MyText" }
    person_id { 1 }
    sts1 { "MyText" }
    sts2 { "MyText" }
  end
end
