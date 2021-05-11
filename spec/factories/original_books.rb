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
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint
#  booktype_id   :bigint
#
# Indexes
#
#  index_original_books_on_book_id      (book_id)
#  index_original_books_on_booktype_id  (booktype_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (booktype_id => booktypes.id)
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
