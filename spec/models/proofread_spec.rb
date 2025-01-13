# frozen_string_literal: true

# == Schema Information
#
# Table name: proofreads
#
#  id            :bigint           not null, primary key
#  address       :text
#  assign_status :integer          not null
#  deleted_at    :datetime
#  email         :text
#  memo          :text
#  order_status  :integer          not null
#  proof_edition :text
#  url           :text
#  work_copy     :integer          default("no_need_copy"), not null
#  work_print    :integer          default("no_need_print"), not null
#  worker_kana   :text
#  worker_name   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  person_id     :bigint           not null
#  work_id       :bigint           not null
#  worker_id     :bigint
#  workfile_id   :bigint
#
# Indexes
#
#  index_proofreads_on_person_id  (person_id)
#  index_proofreads_on_work_id    (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (work_id => works.id)
#

require 'rails_helper'

RSpec.describe Proofread do
  describe '.active' do
    before do
      create(:proofread, deleted_at: nil, memo: '未削除')
      create(:proofread, deleted_at: 1.day.ago, memo: '削除済み')
    end

    it 'activeなものを返す' do
      active_proofreads = Proofread.active
      expect(active_proofreads.count).to eq(1)
      expect(active_proofreads.first.memo).to eq('未削除')
    end
  end
end
