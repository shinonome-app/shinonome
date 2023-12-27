# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class PeopleTableComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(people:, pagy:)
      super
      @header = %w[人物ID 姓名 読み 著作権 他の名前]
      @people = people
      @pagy = pagy
    end
  end
end
