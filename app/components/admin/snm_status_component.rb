# frozen_string_literal: true

module Admin
  # status component for the admin dashboard
  class SnmStatusComponent < ViewComponent::Base
    STYLE_CLASSES = {
      green: 'bg-ab_lightgreen text-ab_green px-3 py-1 rounded-full',
      yellow: 'bg-ab_lightyellow text-ab_yellow px-3 py-1 rounded-full',
      gray: 'bg-ab_lightgray text-ab_gray px-3 py-1 rounded-full'
    }.freeze

    def initialize(status_type:, label:)
      super
      @status_type = (status_type || :green).to_sym
      @label = label
    end

    private

    attr_reader :status_type, :label

    def style_classes
      STYLE_CLASSES[status_type]
    end
  end
end
