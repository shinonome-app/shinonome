# frozen_string_literal: true

module Admin
  class ApplicationController < ActionController::Base
    before_action :authenticate_admin_user!
  end
end
