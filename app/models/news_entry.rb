# frozen_string_literal: true

# == Schema Information
#
# Table name: news_items
#
#  id           :bigint           not null, primary key
#  body         :text             not null
#  flag         :boolean          not null
#  published_on :date
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class NewsEntry < ApplicationRecord
  validates :title, :body, :flag, presence: true
end
