# frozen_string_literal: true

# == Schema Information
#
# Table name: proofreads
#
#  id            :integer          not null, primary key
#  work_id       :integer          not null
#  work_copy     :text
#  work_print    :text
#  proof_edition :text
#  workfile      :integer
#  address       :text
#  memo          :text
#  worker_id     :integer
#  worker_kana   :text
#  worker_name   :text
#  email         :text
#  url           :text
#  person_id     :integer          not null
#  assign_status :text
#  order_status  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_proofreads_on_work_id    (work_id)
#  index_proofreads_on_person_id  (person_id)
#

class Proofread < ApplicationRecord
  belongs_to :work
  belongs_to :workfile
  belongs_to :worker
end
