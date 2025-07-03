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
    command { 'work_list_all' }
    separator { :tab }
    user

    trait :with_result do
      executed_at { Time.current }
      result { { success: true } }
    end

    trait :failed do
      executed_at { Time.current }
      result { { success: false, messages: ['Command execution failed'] } }
    end

    trait :with_comma_separator do
      separator { :comma }
    end
  end
end
