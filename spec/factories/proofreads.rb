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
#  work_copy     :text
#  work_print    :text
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
    work_copy { 'MyText' }
    work_print { 'MyText' }
    proof_edition { 'MyText' }
    workfile
    address { 'MyText' }
    memo { 'MyText' }
    worker
    worker_kana { 'MyText' }
    worker_name { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    person
    assign_status { 'MyText' }
    order_status { 'MyText' }
  end
end
