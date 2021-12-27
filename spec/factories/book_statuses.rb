# frozen_string_literal: true
# == Schema Information
#
# Table name: book_statuses
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  sort_order :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :book_status do
    name { 'MyString' }
    sort_order { 1 }
  end
end
