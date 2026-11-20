# frozen_string_literal: true

module Proofreads
  # 確認画面の「戻る」用。送られた内容で入力画面を表示し直す（保存はしない）
  class EditsController < ApplicationController
    # POST /proofreads/edits
    def create
      @proofread_form = ProofreadForm.new(params.require(:proofread_form).permit(*ProofreadForm::PERMITTED_PARAMS))
      @author = Person.find_by(id: @proofread_form.person_id)
      render 'proofreads/new', status: :unprocessable_entity
    end
  end
end
