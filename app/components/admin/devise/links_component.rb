# frozen_string_literal: true

module Admin
  module Devise
    # ログイン画面の各種リンク用コンポーネント
    class LinksComponent < ViewComponent::Base
      def initialize(resource_name:, devise_mapping:)
        super
        @resource_name = resource_name
        @devise_mapping = devise_mapping
      end
    end
  end
end
