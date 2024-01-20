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

require 'rails_helper'

RSpec.describe Receipt do
  describe '#name' do
    let(:receipt) { create(:receipt) }

    it '正しい名前を返す' do
      expect(receipt.name).to eq '青空 文子'
    end
  end

  describe '#name_kana' do
    let(:receipt) { create(:receipt) }

    it '正しい名前(かな)を返す' do
      expect(receipt.name_kana).to eq 'あおぞら ぶんこ'
    end
  end

  describe '#name_en' do
    let(:receipt) { create(:receipt) }

    it '正しい名前(アルファベット表記)を返す' do
      expect(receipt.name_en).to eq 'Bunko, Aozora'
    end
  end

  describe '#kana_type_name' do
    let(:receipt) { create(:receipt) }

    it '正しい仮名遣い種別を返す' do
      expect(receipt.kana_type_name).to eq '旧字旧仮名'
    end
  end

  describe '#copyright_flag_name' do
    let(:receipt) { create(:receipt) }

    it '正しい著作権表示を返す' do
      expect(receipt.copyright_flag_name).to eq 'なし'
    end
  end
end
