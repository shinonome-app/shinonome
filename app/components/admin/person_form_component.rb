# frozen_string_literal: true

module Admin
  class PersonFormComponent < ViewComponent::Base
    def initialize(person:)
      super
      @person = person
    end
  end
end
