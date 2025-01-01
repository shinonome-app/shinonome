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

# 校正受付
class Proofread < ApplicationRecord
  belongs_to :work
  belongs_to :workfile, optional: true
  belongs_to :worker, optional: true
  belongs_to :person

  enum :assign_status, { non_assigned: 0, assigned: 1 }
  enum :order_status, { non_ordered: 0, ordered: 1 }
  enum :work_copy, { no_need_copy: 0, need_copy: 1 }
  enum :work_print, { no_need_print: 0, need_print: 1 }

  scope :active, -> { where(deleted_at: nil) }

  # delegate :title, :subtitle, :first_teihon,
  #          :kana_type, :translator_text, :inputer_text,
  #          :work_status, :started_on, :workfile,
  #          to: :work

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
