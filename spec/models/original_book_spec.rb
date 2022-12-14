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
#  work_id       :bigint
#  booktype_id   :bigint
#
# Indexes
#
#  index_original_books_on_work_id      (work_id)
#  index_original_books_on_booktype_id  (booktype_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#  fk_rails_...  (booktype_id => booktypes.id)
#

require 'rails_helper'

RSpec.describe OriginalBook do
  pending "add some examples to (or delete) #{__FILE__}"
end
