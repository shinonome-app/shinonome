# frozen_string_literal: true

module Admin
  module Users
    # 管理者管理
    class OthersController < Admin::ApplicationController
      before_action :set_user, only: %i[edit update destroy]

      # GET /users
      def index
        @users = Shinonome::User.order(:id).all
        @user = Shinonome::User.new
      end

      # GET /users/1/edit
      def edit; end

      # POST /users
      def create
        @user = Shinonome::User.new(user_params)
        if @user.save
          redirect_to admin_users_others_path, success: '追加しました.'
        else
          @users = Shinonome::User.order(:id).all
          render :index, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          redirect_to admin_users_others_path, success: '更新しました.'
        else
          render :edit, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy!
        redirect_to admin_users_others_path, success: '削除しました'
      end

      protected

      def set_user
        @user = Shinonome::User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:shinonome_user).permit(:login, :email, :username, :password, :password_confirmation)
      end
    end
  end
end
