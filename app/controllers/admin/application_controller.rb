module Admin
  class ApplicationController < ActionController::Base
    before_action :authenticate_admin_user!
  end
end
