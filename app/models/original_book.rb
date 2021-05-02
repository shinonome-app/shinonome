# == Schema Information
#
# Table name: original_books
#
#  id            :bigint           not null, primary key
#  booktype_name :text
#  first_pubyear :text
#  input_edition :text
#  note          :text
#  proof_edition :text
#  publisher     :text
#  title         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint
#
class OriginalBook < ApplicationRecord
  belongs_to :book
end
