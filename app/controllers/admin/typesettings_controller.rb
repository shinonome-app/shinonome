# frozen_string_literal: true

module Admin
  class TypesettingsController < Admin::ApplicationController
    # GET /admin/typesettings
    def index
      @typesettings = Typesetting.order(:id).all
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
      Rails.logger.info(params[:typesetting][:textfile])
      textfile = params[:typesetting][:textfile]
      @typesetting.user = current_admin_user

      if @typesetting.save
        if textfile.present?
          text = textfile.read
          Dir.mktmpdir("aozora2html") do |tmpdir|
            input_file = File.join(tmpdir, "input.txt")
            output_file = File.join(tmpdir, "output.html")
            File.binwrite(input_file, text)
            input_io = File.open(input_file, 'rb:Shift_JIS:Shift_JIS')
            output_io = File.open(output_file, 'w:Shift_JIS:Shift_JIS')
            begin
              ::Aozora2Html.new(input_io, output_io).process
            rescue Exception => e
              Rails.logger.info(e.inspect)
              Rails.logger.info(e.backtrace.inspect)
            end
            input_io.close
            output_io.close
            FileUtils.cp(output_file, "tmp/hoge2.html")
            send_data File.read(output_file), filename: 'output.html'
          end
        else
          flash.now[:alert] = 'ファイルを指定してください'
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = '入力エラーがあります'
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
