# frozen_string_literal: true

# 校正情報関連付け
class ProofreadAssociator
  def associate_proofread(work:, worker:, proofread_form:)
    WorkWorker.transaction do
      WorkWorker.create!(work:, worker:, worker_role_id: 2)
      update_original_book!(proofread_form, work, 1) if proofread_form.original_book_title.strip.present?
      update_original_book!(proofread_form, work, 2) if proofread_form.original_book_title2.strip.present?

      # 「校正待ち(点検済み)」であれば「校正予約(点検済み)」に変更する
      # それ以外であれば「校正予約(点検前)」に変更する
      if work.proofread_waiting_inspected?
        work.proofread_reserved_inspected!
      else
        work.proofread_reserved!
      end

      proofread = proofread_form.proofread
      proofread.worker = worker
      proofread.assigned!
    end

    Result.new(associated: true)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    Result.new(associated: false)
  end

  def update_original_book!(proofread_form, work, booktype_id)
    original_book = work.original_books.where(booktype_id:).first ||
                    work.original_books.build(
                      booktype_id:,
                      original_book_secret_attributes: { memo: '' }
                    )

    case booktype_id
    when 1
      original_book.title = proofread_form.original_book_title
      original_book.publisher = proofread_form.publisher
      original_book.first_pubdate = proofread_form.first_pubdate
      original_book.input_edition = proofread_form.input_edition
      original_book.proof_edition = proofread_form.proof_edition
    when 2
      original_book.title = proofread_form.original_book_title2
      original_book.publisher = proofread_form.publisher2
      original_book.first_pubdate = proofread_form.first_pubdate2
    else
      raise ArgumentError
    end
    original_book.save!
  end

  # 結果返却用
  class Result
    def initialize(associated:)
      @associated = associated
    end

    def associated?
      @associated
    end
  end
end
