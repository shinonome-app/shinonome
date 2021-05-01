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
require 'rails_helper'

RSpec.describe OriginalBook, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
