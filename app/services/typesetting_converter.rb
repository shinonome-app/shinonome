# frozen_string_literal: true

# 組版変換
class TypesettingConverter
  def convert_file(typesetting:, content:)
    typesetting.content = content.force_encoding('Shift_JIS').encode('UTF-8').slice(0, 100)
    typesetting.save!

    Dir.mktmpdir('aozora2html') do |tmpdir|
      input_file = File.join(tmpdir, 'input.txt')
      output_file = File.join(tmpdir, 'output.html')
      File.binwrite(input_file, content)
      File.open(input_file, 'rb:Shift_JIS:Shift_JIS') do |input_io|
        File.open(output_file, 'w:Shift_JIS:Shift_JIS') do |output_io|
          ::Aozora2Html.new(input_io, output_io).process
        rescue StandardError, ::Aozora2Html::FatalError => e
          Rails.logger.error(e.inspect)
          Rails.logger.error(e.backtrace.inspect)

          return Result.new(converted: false)
        end
      end

      FileUtils.mkdir_p(File.dirname(typesetting.file_path))
      FileUtils.copy(output_file, typesetting.file_path)
    end

    Result.new(converted: true)
  end

  # 結果返却用
  class Result
    def initialize(converted:)
      @converted = converted
    end

    def converted?
      @converted
    end
  end
end
