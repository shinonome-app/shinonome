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
    redirect_to proofreads_person_path(@author), alert: '選択してください' if @proofread_form.sub_works.count < 1
  end

  # POST /proofreads
  def create
    @proofread_form = ProofreadForm.new(proofread_form_params)
    results = @proofread_form.save

    if results
      redirect_to proofreads_thanks_path
    else
      render :new, status: :unprocessable_entity
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
      sub_works_attributes: %i[
        work_id
        work_copy
        work_print
        proof_edition
        enabled
      ]
    )
  end
end
