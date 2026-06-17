# frozen_string_literal: true

# Shift_JIS/CR+LFに正規化する
#
# - valid Shift_JISならそのまま
# - valid UTF-8ならShift_JISに変換 (変換不能文字があれば EncodingError)
# - どちらでもなければ EncodingError
class AozoraTextNormalizer
  class Error < StandardError; end
  class EncodingError < Error; end

  # @param content [String] uploaded raw text (bytestream)
  # @return [String] Shift_JIS・CR+LF text
  # @raise [EncodingError]
  def normalize(content)
    shift_jis_text, source_encoding = to_shift_jis(content)
    normalized = normalize_newlines(shift_jis_text)

    Result.new(
      text: normalized,
      source_encoding:,
      newline_converted: normalized != shift_jis_text
    )
  end

  private

  # @return [Array(String, Symbol)] Shift_JIS文字列と、元の文字コード(:shift_jis / :utf8)
  def to_shift_jis(content)
    bytes = content.b

    if bytes.dup.force_encoding('Shift_JIS').valid_encoding?
      [bytes.force_encoding('Shift_JIS'), :shift_jis]
    elsif bytes.dup.force_encoding('UTF-8').valid_encoding?
      [utf8_to_shift_jis(bytes.force_encoding('UTF-8')), :utf8]
    else
      raise EncodingError, 'ファイルの文字コードを Shift_JIS または UTF-8 として認識できません'
    end
  end

  def utf8_to_shift_jis(text)
    text.encode('Shift_JIS')
  rescue Encoding::UndefinedConversionError => e
    raise EncodingError, "Shift_JIS に変換できない文字が含まれています: 「#{e.error_char}」"
  end

  # ( CR+LF / CR / LF ) -> CR+LF
  def normalize_newlines(text)
    text.gsub(/\r\n|\r|\n/, "\r\n")
  end

  # 結果返却用
  class Result
    attr_reader :text, :source_encoding

    def initialize(text:, source_encoding:, newline_converted:)
      @text = text
      @source_encoding = source_encoding
      @newline_converted = newline_converted
    end

    def newline_converted?
      @newline_converted
    end

    def warnings
      messages = []
      messages << 'アップロードされたファイルは Shift_JIS ではなく UTF-8 でした。Shift_JIS に変換して処理しました。' if source_encoding == :utf8
      messages << '改行コードが CR+LF ではなかったため、CR+LF に変換して処理しました。' if newline_converted?
      messages
    end
  end
end
