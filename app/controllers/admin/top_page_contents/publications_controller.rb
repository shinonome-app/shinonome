# frozen_string_literal: true

module Admin
  module TopPageContents
    class PublicationsController < Admin::ApplicationController
      def create
        value = content_params[:value].to_s
        @editable_content = EditableContent.new(area_name:, key:, value:, status: 'published')

        # 公開前に natsuzora フラグメントとして描画できることを検証する
        NatsuzoraContext::TopBuilder.new.build(editable_content_source: value)

        if @editable_content.save
          redirect_to edit_admin_top_page_content_path, success: 'トップページを公開しました。'
        else
          load_content
          render 'admin/top_page_contents/edit', status: :unprocessable_entity
        end
      rescue Natsuzora::Error => e
        @editable_content.errors.add(:value, "natsuzoraテンプレートとして不正です: #{e.message}")
        load_content
        render 'admin/top_page_contents/edit', status: :unprocessable_entity
      end

      def destroy
        editable_content = EditableContent.latest_published_for(area_name, key)
        editable_content&.destroy
        redirect_to edit_admin_top_page_content_path, success: 'トップページの公開を解除しました。'
      end

      private

      def area_name
        'top'
      end

      def key
        'main'
      end

      def content_params
        params.fetch(:editable_content, {}).permit(:value)
      end

      def load_content
        @draft = EditableContent.latest_draft_for(area_name, key)
        @published = EditableContent.latest_published_for(area_name, key)
        @editable_content ||= EditableContent.new(value: @draft&.value || @published&.value)
        @history = EditableContent.where(area_name:, key:).order(created_at: :desc).limit(50)
      end
    end
  end
end
