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
end
