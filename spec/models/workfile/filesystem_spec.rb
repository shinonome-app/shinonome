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
end
