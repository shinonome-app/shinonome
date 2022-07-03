# frozen_string_literal: true

module Admin
  # 入力受付システム管理画面用Form Object
  class ReceiptForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

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

    def email_is_valid
      errors.add(:email, :blank) if worker_id.blank? && email.blank?
    end

    def save
      return false if invalid?

      set_email

      []
    rescue StandardError => e
      Rails.logger.error(e)
      nil
    end

    private

    def set_email
      if worker_id.present? # rubocop:disable Style/GuardClause
        worker_secret = WorkerSecret.find_by(worker_id: worker_id)
        self.email = worker_secret.email
      end
    end
  end
end
