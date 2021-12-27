# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  last_name       :text             not null
#  last_name_kana  :text             not null
#  last_name_en    :text
#  first_name      :text
#  first_name_kana :text
#  first_name_en   :text
#  born_on         :date
#  died_on         :date
#  copyright_flag  :boolean          not null
#  email           :text
#  url             :text
#  description     :text
#  note_user_id    :integer
#  basename        :text
#  note            :text
#  updated_by      :text
#  sortkey         :text
#  sortkey2        :text
#  input_count     :integer
#  publish_count   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :person do
    last_name { 'MyText' }
    last_name_kana { 'MyText' }
    last_name_en { 'MyText' }
    first_name { 'MyText' }
    first_name_kana { 'MyText' }
    first_name_en { 'MyText' }
    born_on { '2021-04-29' }
    died_on { '2021-04-29' }
    copyright_flag { false }
    email { 'MyText' }
    url { 'MyText' }
    description { 'MyText' }
    note_user_id { 1 }
    basename { 'MyText' }
    note { 'MyText' }
    updated_by { 'MyText' }
    sortkey { 'MyText' }
    sortkey2 { 'MyText' }
    input_count { 1 }
    publish_count { 1 }
  end
end
