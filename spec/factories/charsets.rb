# frozen_string_literal: true
# == Schema Information
#
# Table name: charsets
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :charset do
    name { 'MyText' }
  end
end
