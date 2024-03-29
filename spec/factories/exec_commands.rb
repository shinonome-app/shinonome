# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id          :bigint           not null, primary key
#  command     :text
#  executed_at :datetime
#  result      :jsonb
#  separator   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

FactoryBot.define do
  factory :exec_command, class: 'Shinonome::ExecCommand' do
    command { 'MyText' }
    user_id { '' }
  end
end
