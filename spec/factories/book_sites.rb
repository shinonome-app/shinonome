# frozen_string_literal: true

# == Schema Information
#
# Table name: book_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#  site_id    :bigint
#
FactoryBot.define do
  factory :book_site do
    book_id { 1 }
    site_id { 1 }
  end
end
