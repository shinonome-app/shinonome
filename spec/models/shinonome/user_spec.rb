# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  old_password           :string
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

require 'rails_helper'

RSpec.describe Shinonome::User do
  describe '#valid_password?' do
    context '通常のbcryptパスワードの場合' do
      let(:user) { create(:user, password: 'secret123#') }

      it '正しいパスワードでtrueを返す' do
        expect(user.valid_password?('secret123#')).to be true
      end

      it '誤ったパスワードでfalseを返す' do
        expect(user.valid_password?('wrong')).to be false
      end
    end

    context '旧receptionのmd5パスワード（old_passwordのみ・encrypted_password空）の場合' do
      let(:raw_password) { 'oldpass123' }
      let(:user) do
        # 旧システムからの取り込みを模擬（encrypted_passwordは空、old_passwordにmd5を格納）
        Shinonome::User.create!(username: 'legacyuser', email: 'legacy@example.jp', password: 'temp0000#').tap do |u|
          u.update_columns(encrypted_password: '', old_password: Digest::MD5.hexdigest(raw_password)) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      it '旧md5パスワードでログインできる' do
        expect(user.valid_password?(raw_password)).to be true
      end

      it '誤ったパスワードでは失敗する' do
        expect(user.reload.valid_password?('wrong')).to be false
      end

      it '認証成功時にbcryptへ移行しold_passwordをクリアする' do
        user.valid_password?(raw_password)
        user.reload

        expect(user.old_password).to be_nil
        expect(user.encrypted_password).to be_present
        expect(user.valid_password?(raw_password)).to be true
      end
    end

    context 'bcryptとmd5の両方が設定されている場合' do
      let(:user) do
        create(:user, password: 'bcryptpass#').tap do |u|
          u.update_columns(old_password: Digest::MD5.hexdigest('md5pass')) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      it 'bcryptパスワードで認証できる' do
        expect(user.valid_password?('bcryptpass#')).to be true
      end

      it 'md5パスワードでもフォールバック認証できる' do
        expect(user.valid_password?('md5pass')).to be true
      end
    end
  end
end
