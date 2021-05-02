# == Schema Information
#
# Table name: news
#
#  id           :bigint           not null, primary key
#  body         :text
#  flag         :boolean
#  published_on :date
#  title        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class News < ApplicationRecord
end
