# frozen_string_literal: true

class ProofreadsController < ApplicationController
  include RateLimitedCreate

  # GET /proofreads
  def index; end

  # GET /proofreads/new
  def new
    @proofread_form = ProofreadForm.new(proofread_form_params)
    @author = Person.find(params[:proofread_form][:person_id])
    redirect_to proofreads_person_path(@author), alert: '1つ以上の作品を選択してください' if @proofread_form.sub_works.count < 1
  end

  # POST /proofreads
  def create
    result = ProofreadCreator.new.create_proofread(proofread_form_params)

    if result.created?
      redirect_to proofreads_thanks_path
    else
      @proofread_form = result.proofread_form
      @author = find_author(@proofread_form.person_id)
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def proofread_form_params
    params.require(:proofread_form).permit(*ProofreadForm::PERMITTED_PARAMS)
  end

  def find_author(person_id)
    return nil if person_id.blank?

    Person.find(person_id)
  rescue ActiveRecord::RecordNotFound
    # 著者が見つからない場合はnilを返す
    # ビューでの適切なエラーハンドリングが必要
    nil
  end
end
