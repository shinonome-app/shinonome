class WorkersController < ApplicationController
  # GET /workers
  def index
    @workers = Worker.all
  end
end
