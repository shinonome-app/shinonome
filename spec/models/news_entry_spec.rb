# frozen_string_literal: true

# == Schema Information
#
# Table name: news_entries
#
#  id           :bigint           not null, primary key
#  body         :text             not null
#  flag         :boolean          not null
#  published_on :date
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe NewsEntry do
  pending "add some examples to (or delete) #{__FILE__}"
end
