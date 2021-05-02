# frozen_string_literal: true

class Admin::Devise::LinksComponent < ViewComponent::Base
  def initialize(resource_name:, devise_mapping:)
    super
    @resource_name = resource_name
    @devise_mapping = devise_mapping
  end
end
