# frozen_string_literal: true

# プレビュー画面でのアイテム表示コンポーネント
class PreviewFormItemComponent < ViewComponent::Base
  def initialize(form:, model:, name:, attribute:)
    super
    @form = form
    @model = model
    @name = name
    @attribute = attribute
  end
end
