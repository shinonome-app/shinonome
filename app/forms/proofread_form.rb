# frozen_string_literal: true

# 校正受付システム登録用Form Object
class ProofreadForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  # 底本コピー、プリントアウト等入力用
  class SubWork
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :work_id, :integer
    attribute :work_copy, :integer
    attribute :work_print, :integer
    attribute :proof_edition, :string
    attribute :enabled, :boolean, default: true # checkboxで選択する際に使う

    validates :work_id, presence: true

    delegate :title, :subtitle, :first_teihon,
             :kana_type, :translator_text, :inputer_text,
             :work_status, :started_on, :workfile,
             to: :work

    def work_copy?
      work_copy.to_i == 1
    end

    def work_print?
      work_print.to_i == 1
    end

    def work
      @work ||= Work.find(work_id)
    end
  end

  attribute :address, :string
  attribute :email, :string
  attribute :memo, :string
  attribute :url, :string
  attribute :worker_kana, :string
  attribute :worker_name, :string
  attribute :person_id, :integer
  attribute :work_id, :integer
  attribute :worker_id, :string

  before_validation :set_worker_info

  validates :worker_id, numericality: { only_integer: true }, allow_blank: true
  validates :worker_name, presence: true
  validates :worker_kana, presence: true
  validates :email, presence: true, if: ->(proofread) { proofread.worker_id.blank? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: ->(proofread) { proofread.email.present? }

  validate :need_address
  validate :presence_of_sub_works

  attr_accessor :sub_works

  def self.new_by_author(person)
    sub_works = person.works.not_proofread.map do |work|
      ProofreadForm::SubWork.new(work_id: work.id, enabled: false)
    end

    ProofreadForm.new(sub_works: sub_works, person_id: person.id)
  end

  def save
    return false if invalid?

    set_email

    proofreads = []
    Proofread.transaction do
      sub_works.each do |sub_work|
        proofreads << save_as_proofread!(sub_work)
      end
    end

    proofreads
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end

  def sub_works_attributes=(attributes)
    @sub_works ||= []
    attributes.each do |_i, sub_work_params|
      sub_work = SubWork.new(sub_work_params)
      @sub_works.push(sub_work) if sub_work.enabled
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

  def presence_of_sub_works
    errors.add(:sub_works, :blank, message: '1つ以上選択してください') if sub_works.count < 1
  end

  def need_address
    if address.blank? && sub_works.any? { |sub_work| sub_work.work_copy? || sub_work.work_print? } # rubocop:disable Style/GuardClause, Style/IfUnlessModifier
      errors.add(:address, :blank, message: 'を入力してくだい（底本コピー、プリントアウトが必要な場合は「送付先」が必要となります）')
    end
  end

  def save_as_proofread!(sub_work)
    Rails.logger.info("work_id: #{sub_work.work_id}")
    Proofread.create!(
      address: address,
      email: email,
      memo: memo,
      proof_edition: sub_work.proof_edition,
      url: url,
      work_copy: sub_work.work_copy,
      work_print: sub_work.work_print,
      worker_kana: worker_kana,
      worker_name: worker_name,
      person_id: person_id,
      work_id: sub_work.work_id,
      worker_id: worker_id
    )
  end
end
