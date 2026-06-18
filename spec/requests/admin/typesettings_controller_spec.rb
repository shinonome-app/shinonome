# frozen_string_literal: true

require 'rails_helper'
require 'tempfile'

RSpec.describe Admin::TypesettingsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      Typesetting.create!(user:, original_filename: 'sample.txt', content: '本文')

      get admin_typesettings_url

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      typesetting = Typesetting.create!(user:, original_filename: 'sample.txt', content: '本文')

      get admin_typesetting_url(typesetting)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_admin_typesetting_url

      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested typesetting and redirects to index' do
      typesetting = Typesetting.create!(user:, original_filename: 'sample.txt', content: '本文')

      expect { delete admin_typesetting_url(typesetting) }.to change(Typesetting, :count).by(-1)
      expect(response).to redirect_to(admin_typesettings_url)
    end
  end

  describe 'POST /create' do
    def upload(content, name: 'sample.txt')
      file = Tempfile.new(['sample', '.txt'])
      file.binmode
      file.write(content)
      file.rewind
      Rack::Test::UploadedFile.new(file.path, 'text/plain', original_filename: name)
    end

    after do
      Typesetting.find_each { |t| FileUtils.rm_f([t.source_path.to_s, t.file_path.to_s]) }
    end

    it '正常なファイルは変換して詳細へリダイレクトする' do
      post admin_typesettings_url,
           params: { typesetting: { comment: '', textfile: upload("見出し\r\n\r\n本文です。\r\n".encode('Shift_JIS')) } }

      expect(response).to redirect_to(admin_typesetting_url(Typesetting.last))
      expect(flash[:warning]).to be_blank
    end

    it 'UTF-8など適切なShift_JISでないファイルは変換しつつ警告を表示する' do
      post admin_typesettings_url,
           params: { typesetting: { comment: '', textfile: upload("見出し\n\n本文です。\n".encode('UTF-8')) } }

      expect(response).to redirect_to(admin_typesetting_url(Typesetting.last))
      expect(flash[:warning]).to be_present
      follow_redirect!
      expect(response.body).to include('UTF-8')
    end

    it 'Shift_JISに変換できない文字を含むファイルは500にならず、専用メッセージでnewを再表示する' do
      post admin_typesettings_url,
           params: { typesetting: { comment: '', textfile: upload('絵文字😀'.encode('UTF-8')) } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('変換できない文字')
    end

    it 'ファイル未指定の場合はnewを再表示する' do
      post admin_typesettings_url, params: { typesetting: { comment: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('変換するファイルを指定してください')
    end
  end
end
