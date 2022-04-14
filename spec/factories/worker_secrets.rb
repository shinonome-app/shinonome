# frozen_string_literal: true

# == Schema Information
#
# Table name: worker_secrets
#
#  id         :bigint           not null, primary key
#  email      :text             not null
#  note       :text
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#  worker_id  :bigint           not null
#
# Indexes
#
#  index_worker_secrets_on_user_id    (user_id)
#  index_worker_secrets_on_worker_id  (worker_id)
#

FactoryBot.define do
  factory :worker_secret do
    worker
    email { 'MyText' }
    url { 'MyText' }
    note { 'MyText' }
    user { nil }
  end
end
