# == Schema Information
#
# Table name: proofreads
#
#  id          :bigint           not null, primary key
#  address     :text
#  book_copy   :text
#  book_print  :text
#  email       :text
#  memo        :text
#  refbook     :text
#  sts1        :text
#  sts2        :text
#  url         :text
#  worker_kana :text
#  worker_name :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :bigint
#  bookfile_id :bigint
#  person_id   :bigint
#  worker_id   :bigint
#
FactoryBot.define do
  factory :proofread do
    book_id { 1 }
    book_copy { 'MyText' }
    book_print { 'MyText' }
    refbook { 'MyText' }
    bookfile_id { 1 }
    address { 'MyText' }
    memo { 'MyText' }
    worker_id { 1 }
    worker_kana { 'MyText' }
    worker_name { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    person_id { 1 }
    sts1 { 'MyText' }
    sts2 { 'MyText' }
  end
end
