# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean          default(FALSE), not null
#  deleted_at           :datetime
#  email                :text             not null
#  first_appearance     :text
#  first_name           :text
#  first_name_en        :text
#  first_name_kana      :text
#  first_pubdate        :text             not null
#  first_pubdate2       :text
#  input_edition        :text             not null
#  last_name            :text             not null
#  last_name_en         :text
#  last_name_kana       :text             not null
#  memo                 :text
#  note                 :text
#  original_book_note   :text
#  original_book_title  :text             not null
#  original_book_title2 :text
#  original_title       :text
#  person_note          :text
#  publisher            :text             not null
#  publisher2           :text
#  register_status      :integer          default("non_ordered"), not null
#  started_on           :date             not null
#  subtitle             :text
#  subtitle_kana        :text
#  title                :text             not null
#  title_kana           :text             not null
#  url                  :text
#  worker_kana          :text             not null
#  worker_name          :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  kana_type_id         :text
#  person_id            :bigint
#  work_id              :bigint
#  work_status_id       :bigint           not null
#  worker_id            :bigint
#
# Indexes
#
#  index_receipts_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_status_id => work_statuses.id)
#

FactoryBot.define do
  factory :receipt do
    person
    worker
    title_kana { 'さくひんそのいち' }
    title { '作品その一' }
    subtitle_kana { 'ふくだいそのに' }
    subtitle { '副題その二' }
    original_title { '原題その三' }
    kana_type_id { 1 }
    first_appearance { '初出その4' }
    started_on { '2022-05-10' }
    copyright_flag { false }
    last_name_kana { 'あおぞら' }
    last_name_en { 'Aozora' }
    last_name { '青空' }
    first_name_kana { 'ぶんこ' }
    first_name_en { 'Bunko' }
    first_name { '文子' }
    note { '備考5' }
    person_note { '著者備考6' }
    worker_kana { 'こうさくいん6' }
    worker_name { '耕作員6' }
    email { 'sample@example.com' }
    original_book_title { '底本名7' }
    publisher { '出版社8' }
    first_pubdate { '初版発行年9' }
    input_edition { '入力版10' }
    original_book_title2 { '底本の親本名11' }
    publisher2 { '底本の親本出版社12' }
    first_pubdate2 { '底本の親本初版発行年12' }
    register_status { 1 }
    original_book_note { '底本備考' }

    trait :non_ordered do
      register_status { :non_ordered }
    end

    trait :ordered do
      register_status { :ordered }
    end

    trait :work do
      work do
        association :work,
                    title:,
                    title_kana:,
                    subtitle:,
                    subtitle_kana:,
                    original_title:,
                    kana_type_id:,
                    description: memo,
                    note:
      end
    end
  end
end
