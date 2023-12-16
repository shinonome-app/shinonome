# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_out_path_for(resource_or_scope)
    admin_path
  end
end
