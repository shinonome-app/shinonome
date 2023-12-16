# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(_resource_or_scope)
    admin_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    admin_path
  end
end
