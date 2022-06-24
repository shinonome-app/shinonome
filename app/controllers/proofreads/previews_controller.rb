# frozen_string_literal: true

module Proofreads
  # 校正受付プレビュー用
  class PreviewsController < ApplicationController
    # POST /proofreads/previews
    def create
      @proofread_form = ProofreadForm.new(proofread_form_params)
      @author = Person.find(params[:proofread_form][:person_id])

      if @proofread_form.valid?
        render :new
      else
        render 'proofreads/new', status: :unprocessable_entity
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
        ]
      )
    end
  end
end
