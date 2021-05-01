# == Schema Information
#
# Table name: original_books
#
#  id            :bigint           not null, primary key
#  book_id       :integer
#  title         :text
#  publisher     :text
#  first_pubyear :text
#  input_edition :text
#  proof_edition :text
#  booktype_name :text
#  note          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :original_book do
    book_id { 1 }
    title { "MyText" }
    publisher { "MyText" }
    first_pubyear { "MyText" }
    input_edition { "MyText" }
    proof_edition { "MyText" }
    booktype_name { "MyText" }
    note { "MyText" }
  end
end
