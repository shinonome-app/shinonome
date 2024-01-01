# frozen_string_literal: true

module Admin
  class RegistrationsController < ::Devise::RegistrationsController
    layout 'admin/application'
    # prepend_before_action :require_no_authentication, only: [:cancel]
    # prepend_before_action :authenticate_scope!, only: %i[new create edit update destroy]

    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      redirect_to admin_path
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    def destroy
      redirect_to admin_path
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    def after_update_path_for(resource)
      admin_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[username email])
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end
    def after_sign_in_path_for(resource_or_scope)
      logger.info("SING IN: resource: #{resource_or_scope}")
      admin_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
