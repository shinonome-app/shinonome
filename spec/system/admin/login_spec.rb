require 'rails_helper'

describe 'log_in' do
  let(:username) { 'admin' }
  let(:password) { 'shinonome' }
  let!(:user) { create(:user, username: username, password: password)}

  describe 'sign_in' do
    context '正しいユーザー名、パスワードの場合' do
      it 'ログインできる' do
        visit '/admin/'

        fill_in 'admin_user[login]', with: username
        fill_in 'admin_user[password]', with: password
        click_button 'commit'

        expect(page).to have_content('top page')
      end
    end

    context 'パスワードが正しくない場合' do
      it 'ログインできない' do
        visit '/admin/'

        fill_in 'admin_user[login]', with: username
        fill_in 'admin_user[password]', with: 'invalid-password'
        click_button 'commit'

        expect(page).to have_content('Loginまたはパスワードが違います。')
      end
    end
  end
end
