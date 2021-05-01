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
require 'rails_helper'

RSpec.describe News, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
