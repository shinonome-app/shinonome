# frozen_string_literal: true

# == Schema Information
#
# Table name: booktypes
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :booktype do
    name { 'MyString' }
  end
end
