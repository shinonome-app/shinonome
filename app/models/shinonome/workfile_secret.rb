# frozen_string_literal: true

# == Schema Information
#
# Table name: workfile_secrets
#
#  id          :bigint           not null, primary key
#  memo        :text             default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  workfile_id :bigint           not null
#
# Indexes
#
#  index_workfile_secrets_on_workfile_id  (workfile_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (workfile_id => workfiles.id)
#
module Shinonome
  # 作品ファイル非公開情報
  class WorkfileSecret < ApplicationRecord
    belongs_to :workfile
  end
end
