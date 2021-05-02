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
class Worker < ApplicationRecord
  belongs_to :user
end
