# frozen_string_literal: true

module Admin
  # 校正受付システム管理画面用Form Object
  class ProofreadForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    attr_reader :proofread

    attribute :id, :integer
    attribute :work_id, :integer

    attribute :worker_id, :integer
    attribute :worker_kana, :string
    attribute :worker_name, :string
    attribute :email, :string
    attribute :url, :string

    attribute :address, :string
    attribute :memo, :string

    attribute :original_book_title, :string
    attribute :publisher, :string
    attribute :first_pubdate, :string
    attribute :input_edition, :string
    attribute :proof_edition, :string

    attribute :original_book_title2, :string
    attribute :publisher2, :string
    attribute :first_pubdate2, :string

    validates :worker_kana, presence: true
    validates :worker_name, presence: true
    validates :original_book_title, presence: true
    validates :publisher, presence: true
    validates :first_pubdate, presence: true
    validates :input_edition, presence: true
    validates :worker_id, presence: true

    validate :email_is_valid

    delegate :persisted?, to: :proofread
    delegate :need_copy?, to: :proofread
    delegate :need_print?, to: :proofread
    delegate :address, to: :proofread

    def initialize(params = nil, proofread: Proofread.new)
      @proofread = proofread
      new_params = params || default_params
      super(new_params)

      set_worker
      modify_original_books(work_id) unless params
    end

    def work
      @work || Work.find(work_id)
    end

    def search_similar_workers
      if worker_name.present? || worker_kana.present?
        Worker.where('name ~* ? or name_kana ~* ?', worker_name, worker_kana)
      else
        Worker.none
      end
    end

    def email_is_valid
      errors.add(:email, :blank) if worker_id.blank? && email.blank?
    end

    def save
      return false if invalid?

      set_email

      worker = WorkerFinder.new.find_by_form(self)

      work = @proofread.work
      result = ProofreadAssociator.new.associate_proofread(work: work, worker: worker, proofread_form: self)

      result.associated?
    end

    def to_model
      proofread
    end

    def worker_and_worker_secret
      worker = Worker.find(worker_id) if worker_id

      if worker.present?
        worker_secret = worker.worker_secret
      else
        worker = Worker.new(
          id: worker_id,
          name: worker_name,
          name_kana: worker_kana
        )
        worker_secret = WorkerSecret.new(
          email: email,
          url: url
        )
      end

      [worker, worker_secret]
    end

    private

    def proofread_params
      params.require(:proofread).permit(:id, :title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                        :original_title, :kana_type_id, :author_display_name,
                                        :original_book_title, :publisher, :first_pubdate,
                                        :work_id, :worker_id,
                                        :input_edition, :proof_edition,
                                        :original_book_title2, :publisher2, :first_pubdate2)
    end

    def set_email
      if worker_id.present? # rubocop:disable Style/GuardClause
        worker_secret = WorkerSecret.find_by(worker_id: worker_id)
        self.email = worker_secret.email
      end
    end

    def default_params
      {
        id: @proofread.id,
        work_id: @proofread.work_id,

        worker_id: @proofread.worker_id,
        worker_kana: @proofread.worker_kana,
        worker_name: @proofread.worker_name,
        email: @proofread.email,
        url: @proofread.url,

        # work_copy: @proofread.work_copy,
        # work_print: @proofread.work_print,
        proof_edition: @proofread.proof_edition,
        address: @proofread.address,
        memo: @proofread.memo
      }
    end

    def set_worker
      if worker_id && worker_id >= 0 # rubocop:disable Style/GuardClause
        worker = Worker.find(worker_id)
        self.worker_name = worker.name
        self.worker_kana = worker.name_kana
      end
    end

    def modify_original_books(work_id)
      original_book1 = OriginalBook.find_by(work_id: work_id, worktype_id: 1)
      if original_book1
        self.original_book_title = original_book1.title
        self.publisher = original_book1.publisher
        self.first_pubdate = original_book1.first_pubdate
        self.input_edition = original_book1.input_edition
        self.proof_edition = original_book1.proof_edition
      end

      original_book2 = OriginalBook.find_by(work_id: work_id, worktype_id: 2)
      if original_book2 # rubocop:disable Style/GuardClause
        self.original_book_title2 = original_book2.title
        self.publisher = original_book2.publisher
        self.first_pubdate = original_book2.first_pubdate
      end
    end
  end
end
