# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  email      :text
#  name       :text
#  name_kana  :text
#  note       :text
#  sortkey    :text
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
require 'rails_helper'

RSpec.describe Worker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
