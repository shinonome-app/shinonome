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
class BookSite < ApplicationRecord
  belongs_to :book
  belongs_to :site
end
