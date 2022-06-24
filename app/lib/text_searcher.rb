# frozen_string_literal: true

# テキスト検索時、whereに渡すparamsを構築する
class TextSearcher
  TEXT_SELECTOR = [
    ['を含む', 1],
    ['で始まる', 2],
    ['で終わる', 3],
    ['と等しい', 4]
  ].freeze

  def initialize
    @param_keys = []
    @param_values = []
  end

  def add_query_param(name, text, text_selector_id)
    case text_selector_id
    when 1
      @param_keys << "#{name} like ?"
      @param_values << "%#{text}%"
    when 2
      @param_keys << "#{name} like ?"
      @param_values << "#{text}%"
    when 3
      @param_keys << "#{name} like ?"
      @param_values << "%#{text}"
    when 4
      @param_keys << "#{name} = ?"
      @param_values << text.to_s
    else
      raise 'invalid query'
    end
  end

  def where_params
    # 何もないときは全件検索にする
    if @param_keys.blank?
      where_key = 'true'
    else
      where_key = @param_keys.join(' AND ')
    end

    [where_key, *@param_values]
  end
end
