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
require 'rails_helper'

RSpec.describe OriginalBook, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
