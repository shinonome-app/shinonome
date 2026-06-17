# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AozoraTextNormalizer do
  subject(:normalizer) { AozoraTextNormalizer.new }

  describe '#normalize' do
    it 'Shift_JISはそのまま採用しCR+LFに正規化する' do
      content = "あいう\nかきく".encode('Shift_JIS').b

      result = normalizer.normalize(content)

      expect(result.text.encoding).to eq(Encoding::Shift_JIS)
      expect(result.text).to eq("あいう\r\nかきく".encode('Shift_JIS'))
      expect(result.source_encoding).to eq(:shift_jis)
    end

    it 'UTF-8をShift_JISに変換し、警告を返す' do
      content = "あいう\nかきく".encode('UTF-8').b

      result = normalizer.normalize(content)

      expect(result.text.encoding).to eq(Encoding::Shift_JIS)
      expect(result.text.encode('UTF-8')).to eq("あいう\r\nかきく")
      expect(result.source_encoding).to eq(:utf8)
      expect(result.warnings).to include(a_string_matching(/UTF-8/))
    end

    it 'CR/CRLF/LF混在をCR+LFに揃え、改行変換の警告を返す' do
      content = "a\r\nb\rc\nd".encode('Shift_JIS').b

      result = normalizer.normalize(content)

      expect(result.text.encode('UTF-8')).to eq("a\r\nb\r\nc\r\nd")
      expect(result.newline_converted?).to be true
      expect(result.warnings).to include(a_string_matching(/CR\+LF/))
    end

    it '既にShift_JIS+CR+LFなら警告は無い' do
      content = "あいう\r\nかきく\r\n".encode('Shift_JIS').b

      result = normalizer.normalize(content)

      expect(result.source_encoding).to eq(:shift_jis)
      expect(result.newline_converted?).to be false
      expect(result.warnings).to be_empty
    end

    it 'Shift_JISに変換できない文字を含む場合はEncodingErrorを投げる' do
      content = '絵文字😀'.encode('UTF-8').b

      expect { normalizer.normalize(content) }
        .to raise_error(AozoraTextNormalizer::EncodingError, /変換できない文字/)
    end
  end
end
