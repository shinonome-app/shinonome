# frozen_string_literal: true

# == Schema Information
#
# Table name: book_sites
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  site_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_book_sites_on_book_id  (book_id)
#  index_book_sites_on_site_id  (site_id)
#

class BookSite < ApplicationRecord
  belongs_to :book
  belongs_to :site
end
