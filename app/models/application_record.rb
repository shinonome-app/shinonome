# frozen_string_literal: true

# アプリ内のベースとなるARクラス
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
