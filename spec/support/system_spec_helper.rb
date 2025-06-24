# frozen_string_literal: true

# Rspec support module for sessions (sign in/out)
module SystemSpecHelper
  # from https://github.com/heartcombo/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
  include Warden::Test::Helpers

  def self.included(base)
    base.before { Warden.test_mode! }
    base.after { Warden.test_reset! }
  end

  def sign_in(user)
    login_as(user, scope: :admin_user)
  end

  def log_out
    logout(:admin_user)
  end
end
