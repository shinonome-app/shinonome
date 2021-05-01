# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  name       :text
#  name_kana  :text
#  email      :text
#  url        :text
#  note       :text
#  user_id    :integer
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Worker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
