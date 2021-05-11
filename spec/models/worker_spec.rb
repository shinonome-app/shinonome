# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  email      :text             not null
#  name       :text             not null
#  name_kana  :text             not null
#  note       :text
#  sortkey    :text
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_workers_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Worker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
