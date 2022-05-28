# frozen_string_literal: true

# フォーム画面でのヘッダーエラーメッセージ表示コンポーネント
class FormsErrorHeaderComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    super
    @form = form
  end
end
