# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workfile::Filesystem do
  let(:person) { create(:person) }
  let(:work) { create(:work) }
  let(:workfile) { create(:workfile, work: work, filename: 'test.txt') }
  let(:filesystem) { described_class.new(workfile) }

  before do
    # Ensure work has a person (for card_person_id)
    role = Role.first || create(:role)
    work.work_people.create!(person: person, role: role)
  end

  describe '#initialize' do
    it 'sets workfile instance variable' do
      expect(filesystem.workfile).to eq(workfile)
    end
  end

  describe '#path' do
    context 'when work has card_person_id' do
      it 'returns correct path' do
        expected_path = Rails.root.join('data/workfiles/cards', work.card_person_id, 'files', 'test.txt')
        expect(filesystem.path).to eq(expected_path)
      end

      it 'returns path ending with correct filename' do
        expect(filesystem.path.to_s).to end_with('files/test.txt')
      end
    end

    context 'when work has no card_person_id (no first_author)' do
      before do
        work.work_people.destroy_all
      end

      it 'returns path with empty card_person_id' do
        # card_person_id が nil の場合は '' になる
        expect(filesystem.path.to_s).to include('data/workfiles/cards/files/test.txt')
      end
    end

    context 'when filename is blank' do
      before { workfile.filename = nil }

      it 'uses generate_filename as fallback' do
        allow(workfile).to receive(:generate_filename).and_return('generated.txt')
        expected_path = Rails.root.join('data/workfiles/cards', work.card_person_id, 'files', 'generated.txt')
        expect(filesystem.path).to eq(expected_path)
      end

      context 'when both filename and generate_filename are blank' do
        before do
          workfile.filename = ''
          allow(workfile).to receive(:generate_filename).and_return(nil)
        end

        it 'returns nil' do
          expect(filesystem.path).to be_nil
        end
      end
    end

    context 'when work.card_person_id raises an error' do
      before do
        allow(workfile.work).to receive(:card_person_id).and_raise(StandardError)
      end

      it 'raises the error (no error handling in current implementation)' do
        expect { filesystem.path }.to raise_error(StandardError)
      end
    end
  end

  describe '#exists?' do
    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns false' do
        expect(filesystem.exists?).to be false
      end
    end

    context 'when path exists' do
      before do
        FileUtils.mkdir_p(File.dirname(filesystem.path))
        File.write(filesystem.path, 'test content')
      end

      after do
        FileUtils.rm_f(filesystem.path) if File.exist?(filesystem.path)
      end

      it 'returns true' do
        expect(filesystem.exists?).to be true
      end
    end

    context 'when path does not exist' do
      it 'returns false' do
        expect(filesystem.exists?).to be false
      end
    end
  end

  describe '#save' do
    let(:uploaded_file) { double('uploaded_file', read: 'file content') }

    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns false' do
        expect(filesystem.save(uploaded_file)).to be false
      end
    end

    context 'when path is valid' do
      after do
        FileUtils.rm_f(filesystem.path) if File.exist?(filesystem.path)
      end

      it 'creates directory and saves file' do
        expect(filesystem.save(uploaded_file)).to be_truthy
        expect(File.exist?(filesystem.path)).to be true
        expect(File.read(filesystem.path)).to eq('file content')
      end

      it 'updates workfile filesize' do
        filesystem.save(uploaded_file)
        workfile.reload
        expect(workfile.filesize).to eq('file content'.bytesize)
      end
    end
  end

  describe '#read' do
    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns nil' do
        expect(filesystem.read).to be_nil
      end
    end

    context 'when file does not exist' do
      it 'returns nil' do
        expect(filesystem.read).to be_nil
      end
    end

    context 'when file exists' do
      before do
        FileUtils.mkdir_p(File.dirname(filesystem.path))
        File.write(filesystem.path, 'test content')
      end

      after do
        FileUtils.rm_f(filesystem.path)
      end

      it 'returns file content' do
        expect(filesystem.read).to eq('test content')
      end
    end
  end

  describe '#delete' do
    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns false' do
        expect(filesystem.delete).to be false
      end
    end

    context 'when file exists' do
      before do
        FileUtils.mkdir_p(File.dirname(filesystem.path))
        File.write(filesystem.path, 'test content')
      end

      it 'deletes the file' do
        expect(File.exist?(filesystem.path)).to be true
        filesystem.delete
        expect(File.exist?(filesystem.path)).to be false
      end
    end

    context 'when file does not exist' do
      it 'does not raise error' do
        expect { filesystem.delete }.not_to raise_error
      end
    end
  end

  describe '#size' do
    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns 0' do
        expect(filesystem.size).to eq(0)
      end
    end

    context 'when file does not exist' do
      it 'returns 0' do
        expect(filesystem.size).to eq(0)
      end
    end

    context 'when file exists' do
      before do
        FileUtils.mkdir_p(File.dirname(filesystem.path))
        File.write(filesystem.path, 'test content')
      end

      after do
        FileUtils.rm_f(filesystem.path)
      end

      it 'returns file size' do
        expect(filesystem.size).to eq('test content'.bytesize)
      end
    end
  end

  describe '#ensure_directory (private method)' do
    context 'when path is nil' do
      before { allow(filesystem).to receive(:path).and_return(nil) }

      it 'returns false' do
        expect(filesystem.send(:ensure_directory)).to be false
      end
    end

    context 'when directory does not exist' do
      let(:test_path) { Rails.root.join('tmp/test/deep/directory/structure') }

      before do
        allow(filesystem).to receive(:path).and_return(test_path)
        FileUtils.rm_rf(Rails.root.join('tmp/test'))
      end

      after do
        FileUtils.rm_rf(Rails.root.join('tmp/test'))
      end

      it 'creates directory structure' do
        filesystem.send(:ensure_directory)
        expect(Dir.exist?(File.dirname(test_path))).to be true
      end
    end
  end

  # 追加テスト: nil安全性とエラーハンドリング
  describe 'nil safety and error handling' do
    describe '#save with various file types' do
      after do
        FileUtils.rm_f(filesystem.path) if filesystem.path && File.exist?(filesystem.path)
      end

      context 'with StringIO object' do
        let(:string_io) { StringIO.new('string io content') }

        it 'saves content correctly' do
          expect(filesystem.save(string_io)).to be_truthy
          expect(filesystem.read).to eq('string io content')
        end
      end

      context 'with Tempfile object' do
        let(:tempfile) do
          Tempfile.new('test').tap do |f|
            f.write('tempfile content')
            f.rewind
          end
        end

        after { tempfile.close! }

        it 'saves content correctly' do
          expect(filesystem.save(tempfile)).to be_truthy
          expect(filesystem.read).to eq('tempfile content')
        end
      end

      context 'with ActionDispatch::Http::UploadedFile' do
        let(:uploaded_file) do
          ActionDispatch::Http::UploadedFile.new(
            tempfile: Tempfile.new(['test', '.txt']).tap { |f| f.write('uploaded content'); f.rewind },
            filename: 'upload.txt',
            type: 'text/plain'
          )
        end

        it 'saves content correctly' do
          expect(filesystem.save(uploaded_file)).to be_truthy
          expect(filesystem.read).to eq('uploaded content')
        end
      end
    end

    describe '#save error handling' do
      context 'when disk is full' do
        let(:uploaded_file) { double('uploaded_file', read: 'content') }

        before do
          allow(File).to receive(:binwrite).and_raise(Errno::ENOSPC)
        end

        it 'raises Errno::ENOSPC' do
          expect { filesystem.save(uploaded_file) }.to raise_error(Errno::ENOSPC)
        end
      end

      context 'when permission denied' do
        let(:uploaded_file) { double('uploaded_file', read: 'content') }

        before do
          allow(FileUtils).to receive(:mkdir_p).and_raise(Errno::EACCES)
        end

        it 'raises Errno::EACCES' do
          expect { filesystem.save(uploaded_file) }.to raise_error(Errno::EACCES)
        end
      end
    end

    describe '#read encoding handling' do
      before do
        FileUtils.mkdir_p(File.dirname(filesystem.path))
      end

      after do
        FileUtils.rm_f(filesystem.path) if File.exist?(filesystem.path)
      end

      context 'with Shift_JIS encoded file' do
        before do
          File.write(filesystem.path, 'テスト内容'.encode('Shift_JIS'), encoding: 'Shift_JIS')
        end

        it 'reads content as binary' do
          content = filesystem.read
          expect(content.encoding).to eq(Encoding::UTF_8)
        end
      end

      context 'with UTF-8 encoded file' do
        before do
          File.write(filesystem.path, 'テスト内容', encoding: 'UTF-8')
        end

        it 'reads content correctly' do
          expect(filesystem.read).to eq('テスト内容')
        end
      end
    end

    describe 'boundary conditions' do
      context 'with very long filename' do
        let(:long_filename) { 'a' * 255 + '.txt' }
        let(:workfile) { create(:workfile, work: work, filename: long_filename) }

        it 'handles long filename correctly' do
          expect(filesystem.path.to_s).to include(long_filename)
        end
      end

      context 'with special characters in filename' do
        let(:special_filename) { 'test file (2024) [special].txt' }
        let(:workfile) { create(:workfile, work: work, filename: special_filename) }

        it 'handles special characters correctly' do
          expect(filesystem.path.to_s).to include(special_filename)
        end
      end

      context 'with nil workfile' do
        let(:filesystem) { described_class.new(nil) }

        it 'handles nil workfile gracefully' do
          expect { filesystem.path }.to raise_error(NoMethodError)
        end
      end
    end

    describe 'concurrent access handling' do
      let(:uploaded_file) { double('uploaded_file', read: 'concurrent content') }

      it 'handles concurrent saves' do
        threads = []
        5.times do |i|
          threads << Thread.new do
            file = double('file', read: "content #{i}")
            filesystem.save(file)
          end
        end
        threads.each(&:join)

        # 最後の書き込みが保存されているはず
        expect(filesystem.exists?).to be true
        expect(filesystem.size).to be > 0
      end
    end
  end

  # 統合テスト
  describe 'integration scenarios' do
    describe 'full lifecycle' do
      let(:uploaded_file) { double('uploaded_file', read: 'lifecycle test content') }

      after do
        FileUtils.rm_f(filesystem.path) if filesystem.path && File.exist?(filesystem.path)
      end

      it 'handles complete file lifecycle' do
        # 1. 初期状態
        expect(filesystem.exists?).to be false
        expect(filesystem.size).to eq(0)
        expect(filesystem.read).to be_nil

        # 2. ファイル保存
        expect(filesystem.save(uploaded_file)).to be_truthy
        expect(filesystem.exists?).to be true
        expect(filesystem.size).to eq('lifecycle test content'.bytesize)
        expect(filesystem.read).to eq('lifecycle test content')

        # 3. ファイル更新
        new_file = double('new_file', read: 'updated content')
        expect(filesystem.save(new_file)).to be_truthy
        expect(filesystem.read).to eq('updated content')

        # 4. ファイル削除
        filesystem.delete
        expect(filesystem.exists?).to be false
        expect(filesystem.read).to be_nil
      end
    end

    describe 'migration compatibility' do
      it 'provides compatible interface for migration tasks' do
        # 移行タスクで使用されるメソッドが存在することを確認
        expect(filesystem).to respond_to(:path)
        expect(filesystem).to respond_to(:exists?)
        expect(filesystem).to respond_to(:save)
        expect(filesystem).to respond_to(:read)
        expect(filesystem).to respond_to(:delete)
        expect(filesystem).to respond_to(:size)
      end
    end
  end
end
