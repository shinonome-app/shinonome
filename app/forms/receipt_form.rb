# frozen_string_literal: true

# 入力受付システム登録用Form Object
class ReceiptForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  # 入力受付作品情報
  class SubWork
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :title_kana, :string
    attribute :title, :string
    attribute :subtitle_kana, :string
    attribute :subtitle, :string
    attribute :original_title, :string
    attribute :kana_type_id, :integer
    attribute :first_appearance, :string
    attribute :memo, :string
    attribute :note, :string
    attribute :copyright_flag, :integer

    validates :title_kana, presence: true
    validates :title, presence: true
    validates :copyright_flag, inclusion: { in: [0, 1] }
    validates :kana_type_id, presence: true
    validates :kana_type_id, inclusion: { in: [1, 2, 3, 4, 99] }

    def title_and_subtitle
      if subtitle.present?
        "#{title}　#{subtitle}"
      else
        title
      end
    end

    def kana_type_name
      KanaType.find(kana_type_id).name
    end

    def copyright_flag_name
      copyright_flag.to_i > 0 ? 'あり' : 'なし'
    end
  end

  attribute :worker_id, :integer
  attribute :worker_kana, :string
  attribute :worker_name, :string
  attribute :email, :string
  attribute :url, :string

  attribute :original_book_title, :string
  attribute :publisher, :string
  attribute :first_pubdate, :string
  attribute :input_edition, :string
  attribute :original_book_note
  attribute :original_book_title2, :string
  attribute :publisher2, :string
  attribute :first_pubdate2, :string

  attribute :person_id, :integer
  attribute :last_name_kana, :string
  attribute :last_name, :string
  attribute :first_name_kana, :string
  attribute :first_name, :string
  attribute :person_note, :string

  before_validation :set_worker_info

  validates :worker_kana, presence: true
  validates :worker_name, presence: true

  validates :last_name_kana, presence: true
  validates :last_name, presence: true

  validates :original_book_title, presence: true
  validates :publisher, presence: true
  validates :first_pubdate, presence: true
  validates :input_edition, presence: true

  validate :sub_works_are_valid
  validate :email_is_valid

  def already_registered_works
    sub_works.find_all do |sub_work|
      Work.where(kana_type_id: sub_work.kana_type_id, title: sub_work.title).count > 0
    end
  end

  attr_accessor :sub_works

  def add_work(work)
    self.sub_works ||= []
    self.sub_works << work

    self.sub_works
  end

  def remove_work_at(work_num)
    pos = work_num.to_i
    self.sub_works.delete_at(pos)
  end

  def sub_works_are_valid
    errors.add(:sub_works, I18n.t('errors.messages.invalid')) if sub_works.any?(&:invalid?)
  end

  def email_is_valid
    errors.add(:email, :blank) if worker_id.blank? && email.blank?
  end

  def save
    return false if invalid?

    set_email

    receipts = []

    Receipt.transaction do
      sub_works.each do |sub_work|
        receipts << create_receipt!(sub_work)
      end
    end

    receipts
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end

  def sub_works_attributes=(attributes)
    @sub_works ||= []
    attributes.each do |_i, sub_work_params|
      sub_work = SubWork.new(sub_work_params)
      @sub_works.push(sub_work)
    end
  end

  private

  def set_worker_info
    if worker_id.present? # rubocop:disable Style/GuardClause
      worker = Worker.find(worker_id)
      self.worker_name = worker.name
      self.worker_kana = worker.name_kana
      self.email = ''
    end
  end

  def set_email
    if worker_id.present? # rubocop:disable Style/GuardClause
      worker_secret = WorkerSecret.find_by(worker_id: worker_id)
      self.email = worker_secret.email
    end
  end

  def create_receipt!(sub_work)
    Receipt.create!(
      worker_id: worker_id,
      worker_kana: worker_kana,
      worker_name: worker_name,
      email: email,
      url: url,

      original_book_title: original_book_title,
      publisher: publisher,
      first_pubdate: first_pubdate,
      input_edition: input_edition,
      original_book_note: original_book_note,
      original_book_title2: original_book_title2,
      publisher2: publisher2,
      first_pubdate2: first_pubdate2,

      person_id: person_id,
      last_name_kana: last_name_kana,
      last_name: last_name,
      first_name_kana: first_name_kana,
      first_name: first_name,
      person_note: person_note,

      title_kana: sub_work.title_kana,
      title: sub_work.title,
      subtitle_kana: sub_work.subtitle_kana,
      subtitle: sub_work.subtitle,
      original_title: sub_work.original_title,
      kana_type_id: sub_work.kana_type_id,
      first_appearance: sub_work.first_appearance,
      memo: sub_work.memo,
      note: sub_work.note,
      copyright_flag: sub_work.copyright_flag.to_i > 0
    )
  end
end
