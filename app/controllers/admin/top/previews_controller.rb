# frozen_string_literal: true

module Admin
  module Top
    class PreviewsController < ApplicationController
      layout false

      def index
        context = NatsuzoraContext::TopBuilder.new.build
        html = NatsuzoraRenderer.new.render('top/index.ntzr', context)
        render html: html.html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end
