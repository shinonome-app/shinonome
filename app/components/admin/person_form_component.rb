# frozen_string_literal: true

module Admin
  # 人物用フォーム
  class PersonFormComponent < ViewComponent::Base
    def initialize(person:)
      super
      @person = person
    end
  end
end
