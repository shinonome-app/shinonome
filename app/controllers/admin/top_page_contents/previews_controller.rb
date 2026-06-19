# frozen_string_literal: true

module Admin
  module TopPageContents
    class PreviewsController < Admin::ApplicationController
      layout false

      # プレビュー時のみ Tailwind を CDN で読み込ませ、任意の Tailwind クラスを確実に反映させる。
      PREVIEW_TAILWIND_CDN = '<script src="https://cdn.tailwindcss.com"></script>'

      def create
        source = content_params[:value].to_s
        context = NatsuzoraContext::TopBuilder.new.build(editable_content_source: source)
        html = NatsuzoraRenderer.new.render('top/index.ntzr', context)
        render html: with_preview_styles(html).html_safe # rubocop:disable Rails/OutputSafety
      rescue Natsuzora::Error => e
        render plain: "テンプレートエラー: #{e.message}", status: :unprocessable_entity
      end

      private

      def with_preview_styles(html)
        if html.include?('</head>')
          html.sub('</head>', "#{PREVIEW_TAILWIND_CDN}\n</head>")
        else
          "#{PREVIEW_TAILWIND_CDN}\n#{html}"
        end
      end

      def content_params
        params.fetch(:editable_content, {}).permit(:value)
      end
    end
  end
end
