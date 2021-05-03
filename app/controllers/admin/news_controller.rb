# frozen_string_literal: true

module Admin
  # そらもよう管理
  class NewsController < Admin::ApplicationController
    before_action :set_news, only: %i[show edit update destroy]

    # GET /news
    def index
      @news = News.all
    end

    # GET /news/1
    def show; end

    # GET /news/new
    def new
      @news = News.new
    end

    # GET /news/1/edit
    def edit; end

    # POST /news
    def create
      @news = News.new(news_params)

      if @news.save
        redirect_to [:admin, @news], notice: 'News was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /news/1
    def update
      if @news.update(news_params)
        redirect_to [:admin, @news], notice: 'News was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /news/1
    def destroy
      @news.destroy
      redirect_to admin_news_index_url, notice: 'News was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_params
      params.require(:news).permit(:published_on, :title, :body, :flag)
    end
  end
end
