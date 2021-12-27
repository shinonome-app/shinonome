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

require 'rails_helper'

RSpec.describe News, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
