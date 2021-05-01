# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  book_id    :integer
#  name       :text
#  num        :text
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Bibclasse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
