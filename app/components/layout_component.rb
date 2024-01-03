# frozen_string_literal: true

class LayoutComponent < ViewComponent::Base
  attr_reader :title, :bgcolor

  if defined?(Importmap)
    include Importmap::ImportmapTagsHelper
  end

  def initialize(title: nil, bgcolor: nil)
    super
    @title = title || '青空文庫'
    @bgcolor = bgcolor || 'bg-sky-50'
  end

  private

  def content_security_policy_nonce = nil
  def content_security_policy? = false
end
