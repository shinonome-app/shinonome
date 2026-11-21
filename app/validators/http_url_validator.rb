# frozen_string_literal: true

# 公開フォームの URL 欄用。http: か https: で始まり、空白・制御文字・< > " ' を含まない値だけを通す。
# 日本語などの非 ASCII 文字はそのまま許す（https://ja.wikipedia.org/wiki/夏目漱石 など）。
#
#   validates :url, http_url: true
class HttpUrlValidator < ActiveModel::EachValidator
  PATTERN = %r{\Ahttps?://[^[:space:][:cntrl:]<>"']+\z}i
  MESSAGE = 'はhttp:またはhttps:で始まるURLを入力してください'

  # 前後の空白（全角スペースを含む）を取り除く。貼り付けたときに付きやすいため
  def self.normalize(value)
    value.is_a?(String) ? value.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '') : value
  end

  def validate_each(record, attribute, value)
    return if value.blank? || PATTERN.match?(value)

    record.errors.add(attribute, options[:message] || MESSAGE)
  end
end
