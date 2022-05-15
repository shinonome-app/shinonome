# frozen_string_literal: true

class ProofreadsController < ApplicationController
  # GET /proofreads
  def index
    @proofreads = Proofread.all
  end

  # GET /proofreads/new
  def new
    @proofread_form = ProofreadForm.new(proofread_form_params)
    @author = Person.find(params[:proofread_form][:person_id])
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
  def proofread_form_params
    params.require(:proofread_form).permit(
      :address,
      :memo,
      :worker_id,
      :worker_kana,
      :worker_name,
      :email,
      :url,
      :person_id,
      sub_works_attributes: [
        :work_id,
        :work_copy,
        :work_print,
        :proof_edition,
      ],
    )
  end
end
