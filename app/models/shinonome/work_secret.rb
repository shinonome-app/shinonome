# frozen_string_literal: true

# == Schema Information
#
# Table name: work_secrets
#
#  id         :bigint           not null, primary key
#  memo       :text             default(""), not null
#  orig_text  :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint
#
# Indexes
#
#  index_work_secrets_on_work_id  (work_id)
#
module Shinonome
  # 作品非公開情報
  class WorkSecret < ApplicationRecord
    belongs_to :work
  end
end
