# frozen_string_literal: true

module Admin
  module Top
    class PreviewsController < ApplicationController
      layout false

      def index
        render ::Pages::Top::IndexPageComponent.new
      end
    end
  end
end
