# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :worker do
    transient do
      name_full { Gimei.name }
    end

    name { name_full.kanji }
    name_kana { name_full.hiragana }
    sortkey { name_full.hiragana }
  end
end
