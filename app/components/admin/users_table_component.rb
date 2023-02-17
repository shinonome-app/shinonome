# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class UsersTableComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(users:, pagy:)
      super
      @users = users
      @pagy = pagy
    end

    def before_render
      @header = %w[ID ユーザー名 email]
      @body = @users.map do |user|
        [
          link_to(user.id, edit_admin_users_other_path(user), class: 'underline'),
          link_to(user.username, edit_admin_users_other_path(user), class: 'underline'),
          user.email,
        ]
      end
    end
  end
end
