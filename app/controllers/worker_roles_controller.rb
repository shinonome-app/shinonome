class WorkerRolesController < ApplicationController
  before_action :set_worker_role, only: [:show, :edit, :update, :destroy]

  # GET /worker_roles
  def index
    @worker_roles = WorkerRole.all
  end

  # GET /worker_roles/1
  def show
  end

  # GET /worker_roles/new
  def new
    @worker_role = WorkerRole.new
  end

  # GET /worker_roles/1/edit
  def edit
  end

  # POST /worker_roles
  def create
    @worker_role = WorkerRole.new(worker_role_params)

    if @worker_role.save
      redirect_to @worker_role, notice: 'Worker role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /worker_roles/1
  def update
    if @worker_role.update(worker_role_params)
      redirect_to @worker_role, notice: 'Worker role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /worker_roles/1
  def destroy
    @worker_role.destroy
    redirect_to worker_roles_url, notice: 'Worker role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_worker_role
      @worker_role = WorkerRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def worker_role_params
      params.require(:worker_role).permit(:name)
    end
end
