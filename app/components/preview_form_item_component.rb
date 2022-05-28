# frozen_string_literal: true

# プレビュー画面でのアイテム表示コンポーネント
class PreviewFormItemComponent < ViewComponent::Base
  def initialize(form:, model:, attribute:, name: nil, value: nil)
    super
    @form = form
    @model = model
    @attribute = attribute
    @name = name || @model.class.human_attribute_name(@attribute)
    @value = value || @model.public_send(@attribute)
  end
end
