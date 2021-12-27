# frozen_string_literal: true
# == Schema Information
#
# Table name: original_books
#
#  id            :integer          not null, primary key
#  book_id       :integer
#  title         :text             not null
#  publisher     :text
#  first_pubdate :text
#  input_edition :text
#  proof_edition :text
#  booktype_id   :integer
#  note          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_original_books_on_book_id      (book_id)
#  index_original_books_on_booktype_id  (booktype_id)
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
