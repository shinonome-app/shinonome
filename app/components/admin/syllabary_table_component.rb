# frozen_string_literal: true

module Admin
  # 50音検索用
  class SyllabaryTableComponent < ViewComponent::Base
    TABLES = [
      [
        %w[あ い う え お],
        %w[か き く け こ],
        %w[さ し す せ そ],
        %w[た ち つ て と],
        %w[な に ぬ ね の]
      ],
      [
        %w[は ひ ふ へ ほ],
        %w[ま み む め も],
        ['や', nil, 'ゆ', nil, 'よ'],
        %w[ら り る れ ろ],
        ['わ', 'を', 'ん', nil, nil]
      ]
    ].freeze
    def initialize(key:)
      super
      @key = key
    end
  end
end
