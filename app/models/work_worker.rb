# frozen_string_literal: true

# == Schema Information
#
# Table name: work_workers
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  work_id        :bigint           not null
#  worker_id      :bigint           not null
#  worker_role_id :bigint           not null
#
# Indexes
#
#  index_work_workers_on_work_id         (work_id)
#  index_work_workers_on_worker_id       (worker_id)
#  index_work_workers_on_worker_role_id  (worker_role_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#  fk_rails_...  (worker_id => workers.id)
#  fk_rails_...  (worker_role_id => worker_roles.id)
#

class WorkWorker < ApplicationRecord
  belongs_to :work
  belongs_to :worker
  belongs_to :worker_role
end
