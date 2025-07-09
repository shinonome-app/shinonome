# frozen_string_literal: true

# テキスト検索時、whereに渡すparamsを構築する
class TextSearcher
  TEXT_SELECTOR = [
    ['を含む', 1],
    ['で始まる', 2],
    ['で終わる', 3],
    ['と等しい', 4]
  ].freeze

  # 許可されたカラム名のホワイトリスト
  ALLOWED_COLUMNS = %w[
    collection
    collection_kana
    description
    first_name
    first_name_kana
    last_name
    last_name_kana
    name
    name_kana
    original_title
    owner_name
    subtitle
    subtitle_kana
    title
    title_kana
    url
  ].freeze

  def initialize
    @conditions = []
  end

  def add_query_param(name, text, text_selector_id)
    return if text.blank?

    # カラム名のセキュリティチェック
    raise ArgumentError, "Invalid column name: #{name}. Allowed columns: #{ALLOWED_COLUMNS.join(', ')}" unless ALLOWED_COLUMNS.include?(name.to_s)

    column_name = name.to_s

    case text_selector_id
    when 1
      # を含む
      @conditions << ["#{column_name} LIKE ?", "%#{text}%"]
    when 2
      # で始まる
      @conditions << ["#{column_name} LIKE ?", "#{text}%"]
    when 3
      # で終わる
      @conditions << ["#{column_name} LIKE ?", "%#{text}"]
    when 4
      # と等しい
      @conditions << { column_name => text.to_s }
    else
      raise ArgumentError, 'invalid query selector'
    end
  end

  def where_conditions
    return nil if @conditions.empty?

    @conditions
  end

  def apply_to(collection)
    return collection if @conditions.empty?

    @conditions.each do |condition|
      collection = collection.where(condition)
    end

    collection
  end
end
