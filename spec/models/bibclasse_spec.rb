# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  name       :text
#  note       :text
#  num        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#
require 'rails_helper'

RSpec.describe Bibclasse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
