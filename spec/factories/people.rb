# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :date
#  copyright_flag  :boolean          not null
#  description     :text
#  died_on         :date
#  email           :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text             not null
#  last_name_en    :text
#  last_name_kana  :text             not null
#  note            :text
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :text
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  note_user_id    :bigint
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
