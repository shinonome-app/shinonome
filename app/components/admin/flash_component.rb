# frozen_string_literal: true

class Admin::FlashComponent < ViewComponent::Base
  attr_reader :flash

  def initialize(flash:)
    @flash = flash
  end

  def flash_class(type)
    case type
    when 'notice'
      'bg-blue-200 border-blue-400 text-blue-700'
    when 'success'
      'bg-green-100 border-green-400 text-green-700'
    when 'alert'
      'bg-red-100 border-red-400 text-red-700'
    end
  end

  def flash_icon(type)
    case type
    when 'notice'
      'ℹ️'
    when 'success'
      '✅'
    when 'alert'
      '⚠️️'
    end
  end
end
