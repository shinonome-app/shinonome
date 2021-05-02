# frozen_string_literal: true

# アプリ内のベースとなるARクラス
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
