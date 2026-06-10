# frozen_string_literal: true

module Admin
  module TopPageContents
    class PreviewsController < Admin::ApplicationController
      layout false

      def create
        source = content_params[:value].to_s
        context = NatsuzoraContext::TopBuilder.new.build(editable_content_source: source)
        html = NatsuzoraRenderer.new.render('top/index.ntzr', context)
        render html: html.html_safe # rubocop:disable Rails/OutputSafety
      rescue Natsuzora::Error => e
        render plain: "テンプレートエラー: #{e.message}", status: :unprocessable_entity
      end

      private

      def content_params
        params.fetch(:editable_content, {}).permit(:value)
      end
    end
  end
end
