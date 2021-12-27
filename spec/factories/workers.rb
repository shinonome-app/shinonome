# frozen_string_literal: true
# == Schema Information
#
# Table name: workers
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  email      :text             not null
#  url        :text
#  note       :text
#  user_id    :integer
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_workers_on_user_id  (user_id)
#

FactoryBot.define do
  factory :worker do
    name { 'MyText' }
    name_kana { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    note { 'MyText' }
    user_id { 1 }
    sortkey { 'MyText' }
  end
end
