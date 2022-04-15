# frozen_string_literal: true

# == Schema Information
#
# Table name: filetypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# ファイル種別
class Filetype < ApplicationRecord
  def html?
    # TODO: do not use num literal
    id == 3 || id == 9
  end
end
