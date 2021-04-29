class BookSitesController < ApplicationController
  before_action :set_book_site, only: [:show, :edit, :update, :destroy]

  # GET /book_sites
  def index
    @book_sites = BookSite.all
  end

  # GET /book_sites/1
  def show
  end

  # GET /book_sites/new
  def new
    @book_site = BookSite.new
  end

  # GET /book_sites/1/edit
  def edit
  end

  # POST /book_sites
  def create
    @book_site = BookSite.new(book_site_params)

    if @book_site.save
      redirect_to @book_site, notice: 'Book site was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /book_sites/1
  def update
    if @book_site.update(book_site_params)
      redirect_to @book_site, notice: 'Book site was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /book_sites/1
  def destroy
    @book_site.destroy
    redirect_to book_sites_url, notice: 'Book site was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_site
      @book_site = BookSite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_site_params
      params.require(:book_site).permit(:book_id, :site_id)
    end
end
