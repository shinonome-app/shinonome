# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class SitesTableComponent < ViewComponent::Base
    def initialize(sites:)
      super
      @header = %w[ID サイト名 URL]
      @sites = sites
    end
  end
end
