# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 人物の役割
class Role < ApplicationRecord
  def author?
    id == 1
  end

  def not_author?
    id != 1
  end
end
