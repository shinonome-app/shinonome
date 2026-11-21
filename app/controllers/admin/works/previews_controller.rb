# frozen_string_literal: true

module Admin
  module Works
    class PreviewsController < ApplicationController
      include SandboxedPreview

      layout false

      def show
        work = Work.find(params[:id])
        person = work.people.first
        context = NatsuzoraContext::CardBuilder.new(work, person.id).build
        html = NatsuzoraRenderer.new.render('cards/show.ntzr', context)
        render html: with_preview_styles(html).html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end
