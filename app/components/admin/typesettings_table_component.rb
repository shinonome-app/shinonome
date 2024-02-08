# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class TypesettingsTableComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(typesettings:, pagy:)
      super
      @header = %w[ID 作成日時 ファイル名 コメント]
      @typesettings = typesettings
      @pagy = pagy
    end
  end
end
