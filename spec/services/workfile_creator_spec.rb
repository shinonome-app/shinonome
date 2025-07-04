# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkfileCreator do
  let(:person) { create(:person) }
  let(:work) { create(:work) }
  let(:filetype) { Filetype.find(2) }
  let(:charset) { Charset.find(1) }
  let(:compresstype) { Compresstype.find(1) }
  let(:file_encoding) { FileEncoding.find(1) }
  let(:uploaded_file) do
    file = StringIO.new('test content')
    file.define_singleton_method(:original_filename) { 'test.zip' }
    file
  end

  let(:valid_params) do
    {
      work_id: work.id,
      filetype_id: filetype.id,
      compresstype_id: compresstype.id,
      file_encoding_id: file_encoding.id,
      charset_id: charset.id,
      workfile_secret_attributes: { memo: 'test memo' }
    }
  end

  before do
    # Ensure work has a person for card_person_id
    role = Role.first || create(:role)
    work.work_people.create!(person: person, role: role)
  end

  describe '#create' do
    let(:service) { WorkfileCreator.new }

    context 'with valid parameters and file' do
      it 'creates workfile successfully' do
        result = service.create(valid_params, uploaded_file)

        expect(result).to be_success
        expect(result.workfile).to be_persisted
        expect(result.workfile.filename).to eq('test.zip')
        expect(result.message).to eq('ワークファイルが正常に作成されました。')
      end

      it 'saves file to filesystem' do
        result = service.create(valid_params, uploaded_file)

        expect(result.workfile.filesystem.exists?).to be true
        expect(result.workfile.filesystem.read).to eq('test content')
      end
    end

    context 'when no file is provided' do
      it 'returns failure result' do
        result = service.create(valid_params, nil)

        expect(result).to be_failure
        expect(result.no_file_error?).to be true
        expect(result.message).to eq('ファイルが選択されていません')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { valid_params.merge(filetype_id: nil) }

      it 'returns failure result with validation error' do
        result = service.create(invalid_params, uploaded_file)

        expect(result).to be_failure
        expect(result.validation_error?).to be true
        expect(result.message).to eq('バリデーションエラー')
        expect(result.workfile).not_to be_persisted
      end
    end

    context 'when filesystem save fails' do
      it 'returns failure result and cleans up' do
        # Create a mock filesystem that will fail on save
        filesystem_mock = instance_double(Workfile::Filesystem)
        allow(filesystem_mock).to receive(:save).and_raise(StandardError, 'Disk full')
        allow(filesystem_mock).to receive(:exists?).and_return(false)
        allow(filesystem_mock).to receive(:delete)

        # Mock the filesystem method to return our mock
        allow_any_instance_of(Workfile).to receive(:filesystem).and_return(filesystem_mock)

        result = service.create(valid_params, uploaded_file)

        expect(result).to be_failure
        expect(result.message).to include('ファイル保存に失敗しました: Disk full')
        expect(Workfile.count).to eq(0) # Should be cleaned up
      end
    end
  end

  describe '#update' do
    let(:service) { WorkfileCreator.new }
    let!(:workfile) { create(:workfile, valid_params.merge(filename: 'original.zip')) }

    context 'with file update' do
      let(:new_uploaded_file) do
        file = StringIO.new('updated content')
        file.define_singleton_method(:original_filename) { 'updated.zip' }
        file
      end

      before do
        # Create original file
        workfile.filesystem.save(uploaded_file)
      end

      after do
        workfile.filesystem.delete if workfile.filesystem.exists?
      end

      it 'updates workfile and file successfully' do
        result = service.update(workfile, { charset_id: charset.id }, new_uploaded_file)

        expect(result).to be_success
        expect(result.workfile.filename).to eq('updated.zip')
        expect(result.workfile.filesystem.read).to eq('updated content')
        expect(result.message).to eq('ワークファイルが正常に更新されました。')
      end
    end

    context 'with metadata update only' do
      it 'updates metadata successfully' do
        result = service.update(workfile, { workfile_secret_attributes: { id: workfile.workfile_secret.id, memo: 'updated memo' } }, nil)

        expect(result).to be_success
        expect(result.workfile.workfile_secret.memo).to eq('updated memo')
        expect(result.message).to eq('ワークファイルが正常に更新されました。')
      end
    end

    context 'with invalid metadata' do
      it 'returns failure result' do
        result = service.update(workfile, { filetype_id: nil }, nil)

        expect(result).to be_failure
        expect(result.validation_error?).to be true
      end
    end
  end

  describe '#destroy' do
    let(:service) { WorkfileCreator.new }
    let!(:workfile) { create(:workfile, valid_params.merge(filename: 'to_delete.zip')) }

    before do
      workfile.filesystem.save(uploaded_file)
    end

    it 'destroys workfile and deletes file successfully' do
      expect(workfile.filesystem.exists?).to be true

      result = service.destroy(workfile)

      expect(result).to be_success
      expect(result.message).to eq('削除しました.')
      expect(Workfile.exists?(workfile.id)).to be false
      expect(workfile.filesystem.exists?).to be false
    end
  end

  describe 'Result class' do
    it 'has correct success state' do
      result = described_class::Result.new(success: true, workfile: nil, message: 'success')

      expect(result.success?).to be true
      expect(result.failure?).to be false
    end

    it 'has correct failure state' do
      result = described_class::Result.new(success: false, workfile: nil, message: 'failure', error_type: :validation_error)

      expect(result.success?).to be false
      expect(result.failure?).to be true
      expect(result.validation_error?).to be true
      expect(result.no_file_error?).to be false
    end
  end
end
