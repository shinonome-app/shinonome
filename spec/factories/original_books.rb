# frozen_string_literal: true

# == Schema Information
#
# Table name: original_books
#
#  id            :bigint           not null, primary key
#  first_pubdate :text
#  input_edition :text
#  note          :text
#  proof_edition :text
#  publisher     :text
#  title         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint
#  booktype_id   :bigint
#
FactoryBot.define do
  factory :original_book do
    book_id { 1 }
    title { 'MyText' }
    publisher { 'MyText' }
    first_pubdate { 'MyText' }
    input_edition { 'MyText' }
    proof_edition { 'MyText' }
    booktype_id { 'MyText' }
    note { 'MyText' }
  end
end
