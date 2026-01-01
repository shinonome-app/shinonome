# frozen_string_literal: true

module Admin
  class TopPageContentsController < Admin::ApplicationController
    def edit
      load_content
    end

    def create
      @editable_content = EditableContent.new(area_name:, key:, value: content_params[:value], status: 'draft')

      if @editable_content.save
        redirect_to edit_admin_top_page_content_path, success: '下書きを保存しました。'
      else
        load_content
        render :edit, status: :unprocessable_entity
      end
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
