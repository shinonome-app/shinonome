class Idlists::WorkersController < ApplicationController
  def index
    key = params[:key][0] + "%"
    @workers = Worker.where("name_kana like ?", key).order(:sortkey, :name_kana, :name, :id).all
  end
end
