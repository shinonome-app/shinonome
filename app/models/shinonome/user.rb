# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

module Shinonome
  # ユーザー
  class User < ApplicationRecord
    self.table_name = :users

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable,
           authentication_keys: [:login]

    validates :username, presence: true, uniqueness: { case_sensitive: false }

    # only allow letter, number, underscore and punctuation.
    validates :username, format: { with: /\A[a-zA-Z0-9_.]*\z/, multiline: true }

    attr_writer :login

    def login
      @login || username || email
    end

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      if login
        where(conditions.to_h).find_by('lower(username) = :value OR lower(email) = :value',
                                       { value: login.downcase })
      elsif conditions.key?(:username) || conditions.key?(:email)
        find_by(conditions.to_h)
      end
    end
  end
end
