# frozen_string_literal: true

# == Schema Information
#
# Table name: worktypes
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :worktype do
    name { 'MyString' }
  end
end
