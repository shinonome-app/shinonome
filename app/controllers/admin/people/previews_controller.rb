# frozen_string_literal: true

module Admin
  module People
    class PreviewsController < ApplicationController
      include SandboxedPreview

      layout false

      def show
        person = Person.find(params[:id])
        context = NatsuzoraContext::PersonBuilder.new(person).build
        html = NatsuzoraRenderer.new.render('people/show.ntzr', context)
        render html: with_preview_styles(html).html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end
