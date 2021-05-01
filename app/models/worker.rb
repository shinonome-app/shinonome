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
class Worker < ApplicationRecord
end
