# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class TypesettingsTableComponent < ViewComponent::Base
    def initialize(typesettings:)
      super
      @header = %w[ID ファイル名 コメント]
      @typesettings = typesettings
    end
  end
end
