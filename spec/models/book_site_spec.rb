# frozen_string_literal: true

# == Schema Information
#
# Table name: book_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#  site_id    :bigint           not null
#
# Indexes
#
#  index_book_sites_on_book_id  (book_id)
#  index_book_sites_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (site_id => sites.id)
#
require 'rails_helper'

RSpec.describe BookSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
