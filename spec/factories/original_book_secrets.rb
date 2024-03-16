# frozen_string_literal: true

# == Schema Information
#
# Table name: original_book_secrets
#
#  id               :bigint           not null, primary key
#  memo             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  original_book_id :bigint
#
# Indexes
#
#  index_original_book_secrets_on_original_book_id  (original_book_id)
#

FactoryBot.define do
  factory :original_book_secret, class: 'Shinonome::OriginalBookSecret' do
    memo { '備考original_book' }
  end
end
