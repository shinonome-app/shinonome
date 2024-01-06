# frozen_string_literal: true

# == Schema Information
#
# Table name: filetypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  is_html    :boolean          default(FALSE), not null
#  is_rtxt    :boolean          default(FALSE), not null
#  is_text    :boolean          default(FALSE), not null
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# ファイル種別
class Filetype < ApplicationRecord
  def html?
    is_html
  end

  def text?
    is_text
  end

  def rtxt?
    is_rtxt
  end
end
