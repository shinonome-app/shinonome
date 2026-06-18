# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Typesettings::ResultsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it '結果ファイルを表示し、aozora.cssのパスを書き換える' do
      typesetting = Typesetting.create!(user:, original_filename: 'sample.txt')
      FileUtils.mkdir_p(File.dirname(typesetting.file_path))
      html = %(<link rel="stylesheet" href="../../aozora.css" />本文).encode('Shift_JIS')
      File.binwrite(typesetting.file_path, html.b)

      get admin_typesetting_results_url(typesetting)

      expect(response).to be_successful
      expect(response.media_type).to eq('text/html')
      body = response.body.dup.force_encoding('Shift_JIS')
      expect(body).to include('/css/aozora.css')
      expect(body).not_to include('../../aozora.css')
    ensure
      FileUtils.rm_f(typesetting.file_path.to_s)
    end

    it '結果ファイルが存在しない場合は500ではなく一覧へリダイレクトする' do
      typesetting = Typesetting.create!(user:, original_filename: 'test.txt')

      get admin_typesetting_results_url(typesetting)

      expect(response).to redirect_to(admin_typesettings_path)
      expect(flash[:alert]).to eq('変換結果のファイルが見つかりません')
    end
  end
end
