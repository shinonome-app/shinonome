# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkfileConverter do
  # Phase 3: Filesystemのみ使用

  describe '#convert_format' do
    let(:work) { create(:work, :with_person) }

    after do
      workfile.filesystem.delete if workfile&.filesystem&.exists?
    end

    context 'when converting text to HTML via filesystem' do
      let(:workfile) { create(:workfile, :xhtml, work: work, filename: 'test.txt') }

      before do
        File.open('spec/fixtures/text/01jo.txt', 'rb') do |file|
          workfile.filesystem.save(file)
        end
      end

      it 'converts successfully when Aozora2Html is available' do
        result = WorkfileConverter.new.convert_format(workfile)
        expect(result.converted?).to be true
        expect(workfile.filename).to end_with('.html')
      end

      it 'handles conversion errors gracefully' do
        # Empty file to cause conversion error
        workfile.filesystem.delete
        File.write(workfile.filesystem.path, '')

        result = WorkfileConverter.new.convert_format(workfile)
        expect(result.converted?).to be false
      end

      it 'detects ruby usage correctly' do
        expect(workfile.using_ruby?).to be true
      end
    end

    context 'when converting text to ZIP via filesystem' do
      let(:workfile) { create(:workfile, :zip, work: work, filename: 'test.txt') }

      before do
        File.open('spec/fixtures/text/01jo.txt', 'rb') do |file|
          workfile.filesystem.save(file)
        end
      end

      it 'converts successfully' do
        result = WorkfileConverter.new.convert_format(workfile)

        expect(result.converted?).to be true
        expect(workfile.filename).to end_with('.zip')
        expect(workfile.filesystem.exists?).to be true
      end

      it 'handles ZIP creation errors gracefully' do
        # Delete file to cause error
        workfile.filesystem.delete

        result = WorkfileConverter.new.convert_format(workfile)
        expect(result.converted?).to be false
      end
    end

    context 'when filesystem file does not exist' do
      let(:workfile) { create(:workfile, :xhtml, work: work, filename: 'test.txt') }

      it 'returns unconverted result' do
        result = WorkfileConverter.new.convert_format(workfile)
        expect(result.converted?).to be false
      end
    end

    context 'when file is not a text file' do
      let(:workfile) { create(:workfile, :xhtml, work: work, filename: 'test.html') }

      before do
        File.open('spec/fixtures/html/01jo.html', 'rb') do |file|
          workfile.filesystem.save(file)
        end
      end

      it 'returns unconverted result' do
        result = WorkfileConverter.new.convert_format(workfile)
        expect(result.converted?).to be false
      end
    end
  end
end
