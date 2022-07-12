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

# 校正受付
class Proofread < ApplicationRecord
  belongs_to :work
  belongs_to :workfile, optional: true
  belongs_to :worker, optional: true

  enum assign_status: { non_assigned: 0, assigned: 1 }
  enum order_status: { non_ordered: 0, ordered: 1 }
  enum work_copy: { need_copy: 0, no_need_copy: 1 }
  enum work_print: { need_print: 0, no_need_print: 1 }

  scope :active, -> { where(deleted_at: nil) }

  before_validation :set_statuses

  validates :worker_id, numericality: { only_integer: true }, allow_nil: true
  validates :worker_name, presence: true
  validates :worker_kana, presence: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def set_statuses
    self.assign_status ||= 0
    self.order_status ||= 0
  end
end
