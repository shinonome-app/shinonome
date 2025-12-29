# frozen_string_literal: true

# 校正情報作成
class ProofreadCreator
  def create_proofread(proofread_params)
    proofread_form = ProofreadForm.new(proofread_params)

    if proofread_form.valid?
      proofreads = proofread_form.save

      if proofreads.present?
        UserMailer.register_proofread(proofread_form, proofreads).deliver_now
        Result.new(created: true, proofreads:, proofread_form:)
      else
        # save failed due to database error
        proofread_form.errors.add(:base, '登録中にエラーが発生しました。しばらく経ってから再度お試しください。')
        Result.new(created: false, proofreads: nil, proofread_form:)
      end
    else
      Result.new(created: false, proofreads: nil, proofread_form:)
    end
  end

  # 結果返却用
  class Result
    attr_reader :proofreads, :proofread_form

    def initialize(created:, proofreads:, proofread_form:)
      @created = created
      @proofreads = proofreads
      @proofread_form = proofread_form
    end

    def created?
      @created
    end
  end
end
