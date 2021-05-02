# == Schema Information
#
# Table name: proofreads
#
#  id          :bigint           not null, primary key
#  book_id     :integer
#  book_copy   :text
#  book_print  :text
#  refbook     :text
#  bookfile_id :integer
#  address     :text
#  memo        :text
#  worker_id   :integer
#  worker_kana  :text
#  worker_name :text
#  email       :text
#  url         :text
#  person_id   :integer
#  sts1        :text
#  sts2        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
    worker_kana { "MyText" }
    worker_name { "MyText" }
    email { "MyText" }
    url { "MyText" }
    person_id { 1 }
    sts1 { "MyText" }
    sts2 { "MyText" }
  end
end
