# == Schema Information
#
# Table name: typesettings
#
#  id         :bigint           not null, primary key
#  comment    :text
#  content    :text
#  filename   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  work_id    :bigint
#
# Indexes
#
#  index_typesettings_on_user_id  (user_id)
#  index_typesettings_on_work_id  (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (work_id => works.id)
#
class Typesetting < ApplicationRecord
  belongs_to :user, class_name: 'Shinonome::User'
  belongs_to :work, optional: true
end
