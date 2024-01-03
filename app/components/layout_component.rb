# frozen_string_literal: true

# 静的サイトのレイアウト用
class LayoutComponent < ViewComponent::Base
  attr_reader :title, :bgcolor

  include Importmap::ImportmapTagsHelper if defined?(Importmap)

  def initialize(title: nil, bgcolor: nil)
    super
    @title = title || '青空文庫'
    @bgcolor = bgcolor || 'bg-sky-50'
  end

  private

  def content_security_policy_nonce = nil
  def content_security_policy? = false
end
