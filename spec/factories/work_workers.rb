# frozen_string_literal: true

# == Schema Information
#
# Table name: work_workers
#
#  id             :integer          not null, primary key
#  work_id        :integer          not null
#  worker_id      :integer          not null
#  worker_role_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_work_workers_on_work_id         (work_id)
#  index_work_workers_on_worker_id       (worker_id)
#  index_work_workers_on_worker_role_id  (worker_role_id)
#

FactoryBot.define do
  factory :work_worker do
    work_id { 1 }
    worker_id { 1 }
    worker_role_id { 1 }
  end
end
