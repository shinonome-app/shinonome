FactoryBot.define do
  factory :bookfile do
    book_id { 1 }
    filetype_id { 1 }
    compresstype_id { 1 }
    filesize { 1 }
    user_id { 1 }
    url { "MyText" }
    filename { "MyText" }
    opened_on { "2021-04-29" }
    fixnum { 1 }
    file_encoding_id { "" }
    charset_id { 1 }
    note { "MyText" }
  end
end
