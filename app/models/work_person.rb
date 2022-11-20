# frozen_string_literal: true

# == Schema Information
#
# Table name: work_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  role_id    :bigint           not null
#  work_id    :bigint           not null
#
# Indexes
#
#  index_work_people_on_person_id              (person_id)
#  index_work_people_on_role_id                (role_id)
#  index_work_people_on_work_id                (work_id)
#  index_work_people_on_work_id_and_person_id  (work_id,person_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (work_id => works.id)
#

require 'csv'

# 作品-人物関連付け
class WorkPerson < ApplicationRecord
  belongs_to :work
  belongs_to :person
  belongs_to :role

  validates :person_id, uniqueness: { scope: :work_id, message: 'がすでに関連付けられています' }

  def self.csv_header
    "bookid,人物id,役割フラグ\r\n"
  end

  def to_csv
    array = [work_id, person_id, role.name]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end

  delegate :author?, :not_author?, to: :role
end
