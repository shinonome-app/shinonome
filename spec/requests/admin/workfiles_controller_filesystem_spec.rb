# frozen_string_literal: true

require 'rails_helper'

# Admin::WorkfilesController Filesystem Integration Tests
# ファイルシステム操作を伴うエンドツーエンドの統合テスト
RSpec.describe Admin::WorkfilesController do
  include ActionDispatch::TestProcess::FixtureFile

  let(:work) { create(:work, :with_person) }
  let(:admin) { create(:user, email: 'admin@example.com', username: 'admin') }
  let(:filetype) { Filetype.find(2) }
  let(:charset) { Charset.find(1) }
  let(:compresstype) { Compresstype.find(1) }
  let(:file_encoding) { FileEncoding.find(1) }
  let(:workdata) { fixture_file_upload 'zip/sample.zip' }

  let(:filesystem_attributes) do
    {
      work_id: work.id,
      filetype_id: filetype.id,
      compresstype_id: compresstype.id,
      file_encoding_id: file_encoding.id,
      charset_id: charset.id,
      workdata: workdata,
      filename: 'sample.zip',
      workfile_secret_attributes: { memo: 'filesystem test' }
    }
  end

  before do
    sign_in admin
  end

  after do
    # Clean up filesystem files after each test
    # Skip cleanup when filesystem delete is mocked (to avoid test interference)
    unless RSpec.current_example.metadata[:skip_cleanup]
      last_workfile = Workfile.last
      last_workfile&.filesystem&.delete if last_workfile&.filesystem&.exists?
    end
  end

  describe 'Filesystem integration' do
    describe 'workfile model filesystem interface' do
      it 'provides correct path for filesystem storage' do
        workfile = create(:workfile, work: work, filename: 'integration_test.txt')

        expected_path = Rails.root.join('data/workfiles/cards', work.card_person_id.to_s, 'files', 'integration_test.txt')
        expect(workfile.filesystem.path).to eq(expected_path)
      end

      it 'filesystem responds to required methods' do
        workfile = create(:workfile, work: work)

        expect(workfile.filesystem).to respond_to(:path)
        expect(workfile.filesystem).to respond_to(:exists?)
        expect(workfile.filesystem).to respond_to(:save)
        expect(workfile.filesystem).to respond_to(:read)
        expect(workfile.filesystem).to respond_to(:delete)
        expect(workfile.filesystem).to respond_to(:size)
      end

      it 'controller can access filesystem methods' do
        workfile = create(:workfile, work: work, filename: 'controller_test.txt')

        # Simulate what controller does
        expect { workfile.filesystem.path }.not_to raise_error
        expect { workfile.filesystem.exists? }.not_to raise_error
        expect(workfile.filesystem.exists?).to be false # file not created yet
      end
    end

    context 'when uploading to filesystem (non-test environment)' do
      before do
        allow(Rails.env).to receive(:test?).and_return(false)
      end

      describe 'POST /create with filesystem' do
        it 'saves file to filesystem instead of ActiveStorage' do
          expect do
            post admin_work_workfiles_url(work), params: { workfile: filesystem_attributes }
          end.to change(Workfile, :count).by(1)

          created_workfile = Workfile.last

          # Verify file is saved to filesystem
          expect(created_workfile.filesystem.exists?).to be true
          expect(created_workfile.filesystem.size).to be > 0

          # Verify ActiveStorage is not used
          expect(created_workfile.workdata.attached?).to be false

          expect(response).to redirect_to(admin_work_url(work))
          expect(flash[:success]).to include('ワークファイルが正常に作成されました')
        end

        it 'creates correct filesystem directory structure' do
          post admin_work_workfiles_url(work), params: { workfile: filesystem_attributes }

          created_workfile = Workfile.last
          expected_path = Rails.root.join('data/workfiles/cards', work.card_person_id, 'files', 'sample.zip')

          expect(created_workfile.filesystem.path).to eq(expected_path)
          expect(File.exist?(expected_path)).to be true
        end

        it 'converts file format and saves to filesystem' do
          # Skip conversion test since it requires aozora2html implementation
          skip 'Conversion requires aozora2html implementation'
        end

        it 'handles conversion failure by cleaning up filesystem and database' do
          # Skip this test since it requires specific conversion setup
          skip 'Conversion failure testing requires aozora2html implementation'
        end

        it 'handles filesystem save errors gracefully' do
          # Mock filesystem save to fail
          allow_any_instance_of(Workfile::Filesystem).to receive(:save).and_raise(StandardError, 'Disk full')

          expect do
            post admin_work_workfiles_url(work), params: { workfile: filesystem_attributes }
          end.not_to change(Workfile, :count)

          expect(response).to redirect_to(admin_work_url(work))
          expect(flash[:alert]).to include('ファイル保存に失敗しました: Disk full')
        end
      end

      describe 'PATCH /update with filesystem' do
        let!(:existing_workfile) { Workfile.create!(filesystem_attributes.except(:workdata)) }

        after do
          existing_workfile.filesystem.delete if existing_workfile.filesystem.exists?
        end

        it 'updates workfile metadata successfully' do
          # Test metadata update without file replacement
          patch admin_work_workfile_url(work, existing_workfile),
                params: { workfile: { workfile_secret_attributes: { id: existing_workfile.workfile_secret.id, memo: 'updated memo' } } }

          existing_workfile.reload
          expect(existing_workfile.workfile_secret.memo).to eq('updated memo')
          expect(response).to redirect_to(admin_work_url(work))
        end

        it 'updates workfile with new file' do
          # Create initial file
          existing_workfile.filesystem.save(workdata)
          expect(existing_workfile.filesystem.exists?).to be true

          new_file = fixture_file_upload('zip/sample.zip')
          patch admin_work_workfile_url(work, existing_workfile),
                params: { workfile: { workdata: new_file, workfile_secret_attributes: { id: existing_workfile.workfile_secret.id, memo: 'updated with file' } } }

          expect(response).to redirect_to(admin_work_url(work))
          expect(flash[:success]).to eq('ワークファイルが正常に更新されました。')
          expect(existing_workfile.filesystem.exists?).to be true
        end
      end

      describe 'DELETE /destroy with filesystem' do
        let!(:existing_workfile) { Workfile.create!(filesystem_attributes.except(:workdata)) }

        before do
          existing_workfile.filesystem.save(workdata)
        end

        it 'deletes both database record and filesystem file' do
          file_path = existing_workfile.filesystem.path
          expect(File.exist?(file_path)).to be true

          expect do
            delete admin_work_workfile_url(work, existing_workfile)
          end.to change(Workfile, :count).by(-1)

          expect(File.exist?(file_path)).to be false
          expect(response).to redirect_to(admin_work_url(work))
          expect(flash[:success]).to eq('削除しました.')
        end

        it 'handles filesystem delete errors gracefully', :skip_cleanup do
          # Mock filesystem delete to fail
          allow_any_instance_of(Workfile::Filesystem).to receive(:delete).and_raise(StandardError, 'Permission denied')

          expect do
            delete admin_work_workfile_url(work, existing_workfile)
          end.not_to change(Workfile, :count)

          expect(response).to redirect_to(admin_work_url(work))
          expect(flash[:alert]).to include('削除に失敗しました: Permission denied')
        end
      end
    end
  end
end
