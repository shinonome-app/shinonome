# frozen_string_literal: true

# 組版変換
class TypesettingConverter
  def convert_file(typesetting:, content:)
    normalized = AozoraTextNormalizer.new.normalize(content)
    text = normalized.text

    typesetting.content = leading_chars_for_preview(text, 100)
    typesetting.save!

    write_source_file(typesetting, text)
    result = convert_to_html(typesetting, text)
    result.warnings = normalized.warnings if result.converted?
    result
  rescue AozoraTextNormalizer::Error => e
    Rails.logger.error(e.inspect)
    Result.new(converted: false, error_message: e.message)
  end

  private

  def leading_chars_for_preview(text, num)
    text.encode('UTF-8').slice(0, num)
  end

  # 正規化済み (Shift_JIS + CR+LF) の入力をダウンロード用に保存する。
  def write_source_file(typesetting, normalized)
    FileUtils.mkdir_p(File.dirname(typesetting.source_path))
    File.binwrite(typesetting.source_path, normalized.b)
  end

  def convert_to_html(typesetting, normalized)
    Dir.mktmpdir('aozora2html') do |tmpdir|
      input_file = File.join(tmpdir, 'input.txt')
      output_file = File.join(tmpdir, 'output.html')
      File.binwrite(input_file, normalized.b)
      File.open(input_file, 'rb:Shift_JIS:Shift_JIS') do |input_io|
        File.open(output_file, 'w:Shift_JIS:Shift_JIS') do |output_io|
          ::Aozora2Html.new(input_io, output_io).process
        # aozora2html は致命的エラー時に exit (SystemExit) を投げるため、
        # StandardError だけでなく SystemExit も捕捉して 500 を防ぐ。
        rescue StandardError, SystemExit => e
          Rails.logger.error(e.inspect)
          Rails.logger.error(e.backtrace.inspect)

          return Result.new(converted: false, error_message: '組版変換に失敗しました')
        end
      end

      FileUtils.mkdir_p(File.dirname(typesetting.file_path))
      FileUtils.copy(output_file, typesetting.file_path)
    end

    Result.new(converted: true)
  end

  # 結果返却用
  class Result
    attr_reader :error_message
    attr_accessor :warnings

    def initialize(converted:, error_message: nil, warnings: [])
      @converted = converted
      @error_message = error_message
      @warnings = warnings
    end

    def converted?
      @converted
    end
  end
end
