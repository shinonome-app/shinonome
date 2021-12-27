# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id         :integer          not null, primary key
#  command    :text
#  user_id    :integer
#  separator  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :exec_command do
    command { 'MyText' }
    user_id { '' }
  end
end
