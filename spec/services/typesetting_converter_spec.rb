# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TypesettingConverter do
  let(:user) { create(:user) }
  let(:typesetting) { Typesetting.create!(user:, original_filename: 'test.txt') }

  describe '#convert_file' do
    after { FileUtils.rm_f([typesetting.source_path.to_s, typesetting.file_path.to_s]) }

    it 'UTF-8の内容を正規化して変換し、Shift_JIS+CR+LFの正規化ファイルを保存する' do
      result = TypesettingConverter.new.convert_file(typesetting:, content: "見出し\n\n本文です。\n".encode('UTF-8'))

      expect(result.converted?).to be true
      expect(File.exist?(typesetting.source_path)).to be true
      raw = File.binread(typesetting.source_path)
      expect(raw).to eq("見出し\r\n\r\n本文です。\r\n".encode('Shift_JIS').b)
      # 適切なShift_JISでなかった旨の警告が付く
      expect(result.warnings).to include(a_string_matching(/UTF-8/))
    end

    it 'Shift_JISに変換できない文字を含む場合は例外を投げず converted? false とメッセージを返す' do
      result = nil
      expect do
        result = TypesettingConverter.new.convert_file(typesetting:, content: '絵文字😀'.encode('UTF-8'))
      end.not_to raise_error

      expect(result.converted?).to be false
      expect(result.error_message).to match(/変換できない文字/)
    end
  end
end
