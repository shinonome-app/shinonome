# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  note       :text
#  num        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint           not null
#

FactoryBot.define do
  factory :bibclass do
    work
    name { 'MyText' }
    num { 'MyText' }
    note { 'MyText' }
  end
end
