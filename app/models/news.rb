# == Schema Information
#
# Table name: news
#
#  id           :bigint           not null, primary key
#  published_on :date
#  title        :text
#  body         :text
#  flag         :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class News < ApplicationRecord
end
