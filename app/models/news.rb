# frozen_string_literal: true

# == Schema Information
#
# Table name: news
#
#  id           :integer          not null, primary key
#  published_on :date
#  title        :text             not null
#  body         :text             not null
#  flag         :boolean          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class News < ApplicationRecord
  validates :title, :body, :flag, presence: true
end
