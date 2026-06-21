# frozen_string_literal: true

module Admin
  module People
    class PreviewsController < ApplicationController
      layout false

      # use tailwind CDN for preview
      PREVIEW_TAILWIND_CDN = '<script src="https://cdn.tailwindcss.com"></script>'

      def show
        person = Person.find(params[:id])
        context = NatsuzoraContext::PersonBuilder.new(person).build
        html = NatsuzoraRenderer.new.render('people/show.ntzr', context)
        render html: with_preview_styles(html).html_safe # rubocop:disable Rails/OutputSafety
      end

      private

      def with_preview_styles(html)
        if html.include?('</head>')
          html.sub('</head>', "#{PREVIEW_TAILWIND_CDN}\n</head>")
        else
          "#{PREVIEW_TAILWIND_CDN}\n#{html}"
        end
      end
    end
  end
end
