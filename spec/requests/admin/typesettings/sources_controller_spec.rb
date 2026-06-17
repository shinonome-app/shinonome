# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Typesettings::SourcesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it '正規化済みファイルをShift_JISの添付としてダウンロードできる' do
      typesetting = Typesetting.create!(user:, original_filename: 'sample.txt')
      FileUtils.mkdir_p(File.dirname(typesetting.source_path))
      File.binwrite(typesetting.source_path, "本文です。\r\n".encode('Shift_JIS').b)

      get admin_typesetting_sources_url(typesetting)

      expect(response).to be_successful
      expect(response.headers['Content-Disposition']).to include('attachment')
    ensure
      FileUtils.rm_f(typesetting.source_path.to_s)
    end

    it 'ファイルが存在しない場合は一覧へリダイレクトする' do
      typesetting = Typesetting.create!(user:, original_filename: 'sample.txt')

      get admin_typesetting_sources_url(typesetting)

      expect(response).to redirect_to(admin_typesettings_path)
      expect(flash[:alert]).to eq('正規化済みファイルが見つかりません')
    end
  end
end
