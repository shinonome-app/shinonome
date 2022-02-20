# frozen_string_literal: true

# == Schema Information
#
# Table name: worker_secrets
#
#  id         :integer          not null, primary key
#  worker_id  :integer          not null
#  email      :text             not null
#  url        :text
#  note       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_worker_secrets_on_user_id    (user_id)
#  index_worker_secrets_on_worker_id  (worker_id)
#

class WorkerSecret < ApplicationRecord
  belongs_to :user, class_name: 'Shinonome::User', optional: true
  belongs_to :worker

  validates :email, presence: true
end
