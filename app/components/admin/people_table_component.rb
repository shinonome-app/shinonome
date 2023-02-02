# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class PeopleTableComponent < ViewComponent::Base
    def initialize(people:)
      super
      @header = %w[人物ID 姓名 読み 著作権 他の名前]
      @people = people
    end
  end
end
