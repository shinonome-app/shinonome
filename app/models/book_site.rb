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
class BookSite < ApplicationRecord
  belongs_to :book
  belongs_to :site
end
