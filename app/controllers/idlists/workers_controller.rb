# frozen_string_literal: true

module Idlists
  class WorkersController < ApplicationController
    def index
      key = "#{params[:key][0]}%"
      workers = Worker.where('name_kana like ?', key).order(:sortkey, :name_kana, :name, :id)
      @count = workers.count
      @workers = workers.all
    end
  end
end
