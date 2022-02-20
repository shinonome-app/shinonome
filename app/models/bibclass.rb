# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :integer          not null, primary key
#  work_id    :integer          not null
#  name       :text             not null
#  num        :text             not null
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bibclass < ApplicationRecord
  belongs_to :work
end
