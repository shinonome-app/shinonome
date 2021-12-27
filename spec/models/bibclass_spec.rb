# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  name       :text             not null
#  num        :text             not null
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Bibclass, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
