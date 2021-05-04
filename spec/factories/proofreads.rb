# frozen_string_literal: true

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
#  proof_edition     :text
#  assign_status        :text
#  order_status        :text
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
    proof_edition { 'MyText' }
    bookfile_id { 1 }
    address { 'MyText' }
    memo { 'MyText' }
    worker_id { 1 }
    worker_kana { 'MyText' }
    worker_name { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    person_id { 1 }
    assign_status { 'MyText' }
    order_status { 'MyText' }
  end
end
