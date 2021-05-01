# frozen_string_literal: true

class Admin::PersonFormComponent < ViewComponent::Base
  def initialize(person:)
    @person = person
  end
end
