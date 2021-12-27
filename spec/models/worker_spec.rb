# frozen_string_literal: true
# == Schema Information
#
# Table name: workers
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  email      :text             not null
#  url        :text
#  note       :text
#  user_id    :integer
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_workers_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Worker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
