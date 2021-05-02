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
require 'rails_helper'

RSpec.describe BookSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
