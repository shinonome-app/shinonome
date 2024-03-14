# frozen_string_literal: true

module NewsHelper
  def nl2br(str)
    str.gsub(/\r?\n/, "<br>\n")
  end
end
