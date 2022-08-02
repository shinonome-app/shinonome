# frozen_string_literal: true

# == Schema Information
#
# Table name: work_statuses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  sort_order :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkStatus < ApplicationRecord
  # 1	公開	published
  # 2	非公開	unpublished
  # 3	入力中	inputing
  # 4	入力予約	input_reserverd
  # 5	校正待ち(点検済み)	proofread_waiting_inspected
  # 6	校正待ち(点検前)	proofread_waiting
  # 7	校正予約(点検済み)	proofread_reserved_inspected
  # 8	校正予約(点検前)	proofread_reserved
  # 9	校正中	proofreading
  # 10	校了	proofread_completed
  # 11	翻訳中	translating
  # 12	入力取り消し	input_canceled

  has_many :works, dependent: :restrict_with_error
end
