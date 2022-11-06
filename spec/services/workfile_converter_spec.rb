# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkfileConverter do
  describe '#convert_format' do
    context 'htmlの場合' do
      let(:workfile) do
        create(:workfile, :xhtml, filename: '01jo.txt') do |tmp_workfile|
          tmp_workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/text/01jo.txt', 'text/plain'))
        end
      end

      it 'テキストを渡すと正常に変換される' do
        result = described_class.new.convert_format(workfile)
        expect(result.converted?).to be true
      end

      it '変換後のHTMLは正しい結果になる' do
        result = described_class.new.convert_format(workfile)
        content = result.workfile.workdata.open { |file| file.read }
        content.force_encoding('Shift_JIS').encode('utf-8')
        html_content = file_fixture('html/01jo.html').read
        html_content.force_encoding('Shift_JIS').encode('utf-8')
        expect(content).to eq html_content
      end
    end

    context 'zipの場合' do
      let(:workfile) do
        create(:workfile, :zip, filename: '01jo.txt') do |tmp_workfile|
          tmp_workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/text/01jo.txt', 'text/plain'))
        end
      end

      let(:result) { described_class.new.convert_format(workfile) }

      it 'テキストを渡すと正常に変換される' do
        expect(result.converted?).to be true
      end

      it '変換後のzip内のテキストは正しい結果になる' do
        content = result.workfile.unzip_workdata
        content.force_encoding('Shift_JIS').encode('utf-8')
        text_content = file_fixture('text/01jo.txt').read
        text_content.force_encoding('Shift_JIS').encode('utf-8')
        expect(content).to eq text_content
      end
    end
  end
end
