# frozen_string_literal: true

module Admin
  # そらもよう管理
  class NewsEntriesController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_news_entry, only: %i[show edit update destroy]

    # GET /admin/news_entries
    def index
      @pagy, @news_entries = pagy(NewsEntry.order(published_on: :desc, created_at: :desc).all, items: 50)
    end

    # GET /admin/news_entries/1
    def show; end

    # GET /admin/news_entries/new
    def new
      @news_entry = NewsEntry.new
    end

    # GET /admin/news_entries/1/edit
    def edit; end

    # POST /admin/news_entries
    def create
      @news_entry = NewsEntry.new(news_entry_params)

      if @news_entry.save
        redirect_to admin_news_entries_url, notice: '記事を追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/news_entries/1
    def update
      if @news_entry.update(news_entry_params)
        redirect_to [:admin, @news_entry], notice: '記事を更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/news_entries/1
    def destroy
      @news_entry.destroy
      redirect_to admin_news_entries_url, notice: '記事を削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_news_entry
      @news_entry = NewsEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_entry_params
      params.require(:news_entry).permit(:published_on, :title, :body, :flag)
    end
  end
end
