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
#  index_work_workers_on_work_id                                   (work_id)
#  index_work_workers_on_work_id_and_worker_id_and_worker_role_id  (work_id,worker_id,worker_role_id) UNIQUE
#  index_work_workers_on_worker_id                                 (worker_id)
#  index_work_workers_on_worker_role_id                            (worker_role_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#  fk_rails_...  (worker_id => workers.id)
#  fk_rails_...  (worker_role_id => worker_roles.id)
#

# 作品・工作員関連付け
class WorkWorker < ApplicationRecord
  belongs_to :work
  belongs_to :worker
  belongs_to :worker_role

  validates :worker_id, uniqueness: { scope: %i[work_id worker_role_id], message: 'がすでに関連付けられています' }

  def self.csv_header
    "bookid,工作員id,役割フラグ\r\n"
  end

  def to_csv
    array = [work_id, worker_id, worker_role.name]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
