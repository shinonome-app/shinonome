# frozen_string_literal: true

# 入力情報関連付け
#
# * 作品追加
# * 著者関連付け(+新規人物登録)
# * 入力者関連付け
# * 底本関連付け(=新規登録)
# * 底本の親本関連付け(=新規登録)
# * 状態更新
# * (メール送信)
#
class ReceiptAssociator
  def associate_receipt(worker:, person:, current_admin_user:, receipt_form:)
    Work.transaction do
      work = Work.create!(
        title: receipt_form.title,
        title_kana: receipt_form.title_kana,
        subtitle: receipt_form.subtitle,
        subtitle_kana: receipt_form.subtitle_kana,
        original_title: receipt_form.original_title,
        first_appearance: receipt_form.first_appearance,
        note: receipt_form.note,
        kana_type_id: receipt_form.kana_type_id,
        copyright_flag: receipt_form.copyright_flag,
        work_status_id: receipt_form.work_status_id,
        started_on: receipt_form.started_on,
        user_id: current_admin_user.id,
        description: receipt_form.memo,
        work_secret_attributes: { memo: '' }
      )
      WorkPerson.create!(work:, person:, role_id: 1)
      WorkWorker.create!(work:, worker:, worker_role_id: 1)

      add_original_book!(receipt_form, work, 1) if receipt_form.original_book_title&.strip.present?

      add_original_book!(receipt_form, work, 2) if receipt_form.original_book_title2&.strip.present?

      receipt = receipt_form.receipt

      receipt.update!(
        work_id: work.id,
        worker_id: worker.id,
        person_id: person.id,
        started_on: receipt_form.started_on,
        title: receipt_form.title,
        title_kana: receipt_form.title_kana,
        subtitle: receipt_form.subtitle,
        subtitle_kana: receipt_form.subtitle_kana,
        original_title: receipt_form.original_title,
        kana_type_id: receipt_form.kana_type_id,
        first_appearance: receipt_form.first_appearance,
        memo: receipt_form.memo,
        note: receipt_form.note,
        work_status_id: receipt_form.work_status_id,
        copyright_flag: receipt_form.copyright_flag,
        original_book_title: receipt_form.original_book_title,
        publisher: receipt_form.publisher,
        first_pubdate: receipt_form.first_pubdate,
        input_edition: receipt_form.input_edition,
        original_book_note: receipt_form.original_book_note,
        original_book_title2: receipt_form.original_book_title2,
        publisher2: receipt_form.publisher2,
        first_pubdate2: receipt_form.first_pubdate2,
        register_status: :ordered
      )
    end

    Result.new(associated: true)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    Result.new(associated: false)
  end

  def add_original_book!(receipt_form, work, booktype_id)
    case booktype_id
    when 1
      OriginalBook.create!(
        work_id: work.id,
        booktype_id:,
        title: receipt_form.original_book_title,
        publisher: receipt_form.publisher,
        first_pubdate: receipt_form.first_pubdate,
        input_edition: receipt_form.input_edition,
        original_book_secret_attributes: { memo: '' }
      )
    when 2
      OriginalBook.create!(
        work_id: work.id,
        booktype_id:,
        title: receipt_form.original_book_title2,
        publisher: receipt_form.publisher2,
        first_pubdate: receipt_form.first_pubdate2,
        input_edition: receipt_form.input_edition,
        original_book_secret_attributes: { memo: '' }
      )
    else
      raise ArgumentError
    end
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
