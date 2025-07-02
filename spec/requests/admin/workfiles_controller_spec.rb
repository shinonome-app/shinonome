# frozen_string_literal: true

require 'rails_helper'

# Admin::WorkfilesController Basic CRUD Tests
# 基本的なHTTP操作とコントローラーロジックのテスト
# filesystem操作を含まない軽量なテスト
# filesystem統合テストは workfiles_controller_filesystem_spec.rb を参照
RSpec.describe Admin::WorkfilesController do
  include ActionDispatch::TestProcess::FixtureFile

  # Workfile. As you add validations to Workfile, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      work_id: work.id,
      filetype_id: filetype.id,
      compresstype_id: compresstype.id,
      file_encoding_id: file_encoding.id,
      charset_id: charset.id,
      filesize: 12_345,
      filename: 'sample.zip',
      workdata:,
      revision_count: 1,
      workfile_secret_attributes: { memo: 'test' }
    }
  end

  let(:invalid_attributes) do
    {
      work_id: work.id,
      filetype_id: 'test',
      compresstype_id: compresstype.id,
      file_encoding_id: file_encoding.id,
      charset_id: charset.id
    }
  end

  let(:work) { create(:work) }
  let(:filetype) { Filetype.find(2) }
  let(:admin) { create(:user, email: 'admin1@example.com', username: 'admin1') }
  let(:user) { create(:user) }
  let(:charset) { Charset.find(1) }
  let(:compresstype) { Compresstype.find(1) }
  let(:file_encoding) { FileEncoding.find(1) }
  let(:workdata) { fixture_file_upload 'zip/sample.zip' }

  before { sign_in(admin) }

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_admin_work_workfile_url(work)
      expect(response).to be_successful
    end

    it 'displays the new workfile form' do
      get new_admin_work_workfile_url(work)
      expect(response.body).to include('作品ファイル')
      expect(response.body).to include('登録する')
    end
  end

  describe 'GET /edit' do
    let!(:workfile) { Workfile.create!(valid_attributes) }

    it 'render a successful response' do
      get edit_admin_work_workfile_url(workfile.work, workfile)
      expect(response).to be_successful
    end

    it 'displays the edit workfile form' do
      get edit_admin_work_workfile_url(workfile.work, workfile)
      expect(response.body).to include('作品ファイル')
      expect(response.body).to include('登録する')
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Workfile' do
        expect do
          post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        end.to change(Workfile, :count).by(1)
      end

      it 'redirects to the created workfile with success message' do
        post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        expect(response).to redirect_to(admin_work_url(work))
        expect(flash[:success]).to eq('ワークファイルが正常に作成されました。')
      end

      it 'sets correct filename from uploaded file' do
        post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        created_workfile = Workfile.last
        expect(created_workfile.filename).to eq('sample.zip')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Workfile' do
        expect do
          post admin_work_workfiles_url(work), params: { workfile: invalid_attributes }
        end.not_to change(Workfile, :count)
      end

      it 'renders new template with validation errors' do
        post admin_work_workfiles_url(work), params: { workfile: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('作品ファイル')
      end
    end

    context 'when no file is uploaded' do
      let(:attributes_without_file) { valid_attributes.except(:workdata) }

      it 'does not create a workfile' do
        expect do
          post admin_work_workfiles_url(work), params: { workfile: attributes_without_file }
        end.not_to change(Workfile, :count)
      end

      it 'renders new template' do
        post admin_work_workfiles_url(work), params: { workfile: attributes_without_file }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when WorkfileCreator service fails' do
      before do
        allow_any_instance_of(WorkfileCreator).to receive(:create) # rubocop:disable RSpec/AnyInstance
          .and_return(WorkfileCreator::Result.failure(nil, 'Service error', :service_error))
      end

      it 'redirects with error message' do
        post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        expect(response).to redirect_to(admin_work_url(work))
        expect(flash[:alert]).to eq('Service error')
      end
    end
  end

  describe 'PATCH /update' do
    let!(:workfile) { Workfile.create!(valid_attributes) }

    context 'with valid parameters' do
      let(:new_attributes) do
        {
          work_id: work.id,
          filetype_id: filetype.id,
          user_id: user.id,
          compresstype_id: compresstype.id,
          file_encoding_id: file_encoding.id,
          charset_id: charset.id,
          filesize: 12_121,
          filename: 'sample.zip',
          revision_count: 1,
          workfile_secret_attributes: { memo: 'test2' }
        }
      end

      it 'updates the requested workfile' do
        patch admin_work_workfile_url(work, workfile), params: { workfile: new_attributes }
        workfile.reload
        expect(workfile.workfile_secret&.memo).to eq 'test2'
      end

      it 'redirects to the workfile with success message' do
        patch admin_work_workfile_url(work, workfile), params: { workfile: new_attributes }
        expect(response).to redirect_to(admin_work_url(work))
        expect(flash[:success]).to eq('ワークファイルが正常に更新されました。')
      end
    end

    context 'with file upload' do
      let(:new_file) { fixture_file_upload('zip/sample.zip') }
      let(:params_with_file) { { workfile_secret_attributes: { memo: 'updated with file' }, workdata: new_file } }

      it 'updates workfile with new file' do
        patch admin_work_workfile_url(work, workfile), params: { workfile: params_with_file }
        expect(response).to redirect_to(admin_work_url(work))
        expect(flash[:success]).to eq('ワークファイルが正常に更新されました。')
      end
    end

    context 'with invalid parameters' do
      it 'renders edit template with validation errors' do
        patch admin_work_workfile_url(work, workfile), params: { workfile: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('作品ファイル')
      end
    end

    context 'when WorkfileCreator service fails' do
      before do
        allow_any_instance_of(WorkfileCreator).to receive(:update) # rubocop:disable RSpec/AnyInstance
          .and_return(WorkfileCreator::Result.failure(workfile, 'Update failed', :update_error))
      end

      it 'renders edit template' do
        patch admin_work_workfile_url(work, workfile), params: { workfile: { memo: 'test' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:workfile) { Workfile.create!(valid_attributes) }

    it 'destroys the requested workfile' do
      expect do
        delete admin_work_workfile_url(work, workfile)
      end.to change(Workfile, :count).by(-1)
    end

    it 'redirects to the work page with success message' do
      delete admin_work_workfile_url(work, workfile)
      expect(response).to redirect_to(admin_work_url(work))
      expect(flash[:success]).to eq('削除しました.')
    end

    context 'when WorkfileCreator service fails' do
      before do
        allow_any_instance_of(WorkfileCreator).to receive(:destroy) # rubocop:disable RSpec/AnyInstance
          .and_return(WorkfileCreator::Result.failure(workfile, 'Delete failed', :delete_error))
      end

      it 'redirects with error message' do
        delete admin_work_workfile_url(work, workfile)
        expect(response).to redirect_to(admin_work_url(work))
        expect(flash[:alert]).to eq('Delete failed')
      end

      it 'does not destroy the workfile' do
        expect do
          delete admin_work_workfile_url(work, workfile)
        end.not_to change(Workfile, :count)
      end
    end
  end
end
