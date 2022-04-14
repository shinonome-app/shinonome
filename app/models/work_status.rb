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
  has_many :works, dependent: :restrict_with_error
end
