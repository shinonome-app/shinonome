# == Schema Information
#
# Table name: book_sites
#
#  id         :bigint           not null, primary key
#  book_id    :integer
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :book_site do
    book_id { 1 }
    site_id { 1 }
  end
end
