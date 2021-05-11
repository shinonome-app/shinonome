# frozen_string_literal: true

class ProofreadsController < ApplicationController
  # GET /proofreads
  def index
    @proofreads = Proofread.all
  end

  # GET /proofreads/new
  def new
    @proofread = Proofread.new
  end

  # POST /proofreads
  def create
    @proofread = Proofread.new(proofread_params)

    if @proofread.save
      redirect_to @proofread, notice: 'Proofread was successfully created.'
    else
      render :new
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def proofread_params
    params.require(:proofread).permit(:book_id, :book_copy, :book_print, :proof_edition, :bookfile_id, :address, :memo,
                                      :worker_id, :worker_kana, :worker_name, :email, :url, :person_id, :assign_status, :order_status)
  end
end
