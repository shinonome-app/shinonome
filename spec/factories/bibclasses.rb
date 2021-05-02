# frozen_string_literal: true

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
FactoryBot.define do
  factory :bibclasse do
    book_id { 1 }
    name { 'MyText' }
    num { 'MyText' }
    note { 'MyText' }
  end
end
