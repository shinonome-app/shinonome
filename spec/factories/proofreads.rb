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
#  workfile      :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  person_id     :bigint           not null
#  work_id       :bigint           not null
#  worker_id     :bigint
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

FactoryBot.define do
  factory :proofread do
    work
    work_copy { 1 }
    work_print { 1 }
    proof_edition { '校正使用版1' }
    workfile
    address { "〒100-0001\n東京都千代田区千代田1-1-1-111\n青空太郎" }
    memo { '連絡事項1' }
    worker
    worker_kana { 'あおぞらたろう' }
    worker_name { '青空太郎' }
    email { 'proofread@example.com' }
    url { 'https://example.com/proofread' }
    person
    assign_status { 0 }
    order_status { 0 }
  end
end
