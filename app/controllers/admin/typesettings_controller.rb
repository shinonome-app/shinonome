# frozen_string_literal: true

module Admin
  class TypesettingsController < Admin::ApplicationController
    include Pagy::Backend

    # GET /admin/typesettings
    def index
      @pagy, @typesettings = pagy(Typesetting.order(id: :desc).all, items: 20)
    end

    # GET /admin/typesettings/1
    def show
      @typesetting = Typesetting.find(params[:id])
    end

    # GET /admin/typesettings/new
    def new
      @typesetting = Typesetting.new
    end

    # POST /admin/typesettings
    def create
      @typesetting = Typesetting.new(typesetting_params)
      textfile = params[:typesetting][:textfile]
      if textfile.blank?
        flash.now[:alert] = '変換するファイルを指定してください'
        render :new, status: :unprocessable_entity
        return
      end

      @typesetting.user = current_admin_user
      @typesetting.original_filename = textfile&.original_filename

      unless @typesetting.save
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end

      content = textfile.read
      result = TypesettingConverter.new.convert_file(typesetting: @typesetting, content:)
      if result.converted?
        redirect_to admin_typesetting_path(@typesetting), success: '変換しました'
      else
        flash.now[:alert] = '変換できませんでした'
        render :new, status: :unprocessable_entity
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def typesetting_params
      params.require(:typesetting).permit(:comment)
    end
  end
end
