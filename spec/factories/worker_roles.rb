# frozen_string_literal: true

# == Schema Information
#
# Table name: worker_roles
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :worker_role do
    name { 'MyText' }
  end
end
