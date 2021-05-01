# == Schema Information
#
# Table name: bookfiles
#
#  id               :bigint           not null, primary key
#  book_id          :integer
#  filetype_id      :integer
#  compresstype_id  :integer
#  filesize         :integer
#  user_id          :integer
#  url              :text
#  filename         :text
#  opened_on        :date
#  fixnum           :integer
#  file_encoding_id :integer
#  charset_id       :integer
#  note             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
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
