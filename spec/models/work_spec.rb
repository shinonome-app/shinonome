# frozen_string_literal: true

# == Schema Information
#
# Table name: works
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean          default(FALSE), not null
#  description           :text
#  first_appearance      :text
#  note                  :text
#  original_title        :text
#  sortkey               :text
#  started_on            :date             not null
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text             not null
#  title_kana            :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description_person_id :bigint
#  kana_type_id          :bigint           not null
#  user_id               :bigint           not null
#  work_status_id        :bigint           not null
#
# Indexes
#
#  index_works_on_kana_type_id    (kana_type_id)
#  index_works_on_user_id         (user_id)
#  index_works_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (kana_type_id => kana_types.id)
#  fk_rails_...  (work_status_id => work_statuses.id)
#

require 'rails_helper'

RSpec.describe Work do
  describe '#full_title' do
    context 'no subtitle' do
      let(:work) { create(:work, title: '作品名123', subtitle: nil) }

      it 'is just title' do
        expect(work.full_title).to eq '作品名123'
      end
    end

    context 'with subtitle' do
      let(:work) { create(:work, title: '作品名123', subtitle: '副題abc') }

      it 'is title and subtitle' do
        expect(work.full_title).to eq '作品名123 副題abc'
      end
    end
  end
end
