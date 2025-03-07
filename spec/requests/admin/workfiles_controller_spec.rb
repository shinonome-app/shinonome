# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

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
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      workfile = Workfile.create! valid_attributes
      get edit_admin_work_workfile_url(workfile.work, workfile)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Workfile' do
        expect do
          post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        end.to change(Workfile, :count).by(1)
      end

      it 'redirects to the created workfile' do
        post admin_work_workfiles_url(work), params: { workfile: valid_attributes }
        expect(response).to redirect_to(admin_work_url(work))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Workfile' do
        expect do
          post admin_work_workfiles_url(work), params: { workfile: invalid_attributes }
        end.not_to change(Workfile, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_work_workfiles_url(work), params: { workfile: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH /update' do
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
        workfile = Workfile.create! valid_attributes
        patch admin_work_workfile_url(work, workfile), params: { workfile: new_attributes }
        workfile.reload
        expect(workfile.workfile_secret&.memo).to eq 'test2'
      end

      it 'redirects to the workfile' do
        workfile = Workfile.create! valid_attributes
        patch admin_work_workfile_url(work, workfile), params: { workfile: new_attributes }
        workfile.reload
        expect(response).to redirect_to(admin_work_url(work))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        workfile = Workfile.create! valid_attributes
        patch admin_work_workfile_url(work, workfile), params: { workfile: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested workfile' do
      workfile = Workfile.create! valid_attributes
      expect do
        delete admin_work_workfile_url(work, workfile)
      end.to change(Workfile, :count).by(-1)
    end

    it 'redirects to the workfiles list' do
      workfile = Workfile.create! valid_attributes
      delete admin_work_workfile_url(work, workfile)
      expect(response).to redirect_to(admin_work_url(work))
    end
  end
end
