# frozen_string_literal: true

# == Schema Information
#
# Table name: original_book_secrets
#
#  id               :bigint           not null, primary key
#  memo             :text             default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  original_book_id :bigint           not null
#
# Indexes
#
#  index_original_book_secrets_on_original_book_id  (original_book_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (original_book_id => original_books.id)
#
module Shinonome
  # 底本非公開情報
  class OriginalBookSecret < ApplicationRecord
    belongs_to :original_book
  end
end
