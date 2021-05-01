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
require 'rails_helper'

RSpec.describe BookSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
