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

FactoryBot.define do
  factory :bibclasse do
    book_id { 1 }
    name { 'MyText' }
    num { 'MyText' }
    note { 'MyText' }
  end
end
