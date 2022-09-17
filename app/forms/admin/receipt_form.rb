# frozen_string_literal: true

module Admin
  # 入力受付システム管理画面用Form Object
  class ReceiptForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks
    include ActiveRecord::AttributeAssignment

    attr_reader :receipt, :current_admin_user

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
    attribute :last_name_en, :string
    attribute :first_name_kana, :string
    attribute :first_name, :string
    attribute :first_name_en, :string
    attribute :person_note, :string
    attribute :born_on, :string
    attribute :died_on, :string
    attribute :person_sortkey, :string
    attribute :person_sortkey2, :string

    attribute :first_appearance, :string
    attribute :memo, :string
    attribute :note, :string
    attribute :started_on, :date
    attribute :title, :string
    attribute :title_kana, :string
    attribute :subtitle, :string
    attribute :subtitle_kana, :string
    attribute :original_title, :string
    attribute :kana_type_id, :integer
    attribute :work_id, :integer
    attribute :work_status_id, :integer
    attribute :copyright_flag, :boolean
    attribute :sortkey, :string

    attribute :no_send_mail, :integer
    attribute :cc_flag, :integer

    before_validation :set_worker_info
    before_validation :set_person_info
    before_validation :set_sortkey

    validates :worker_id, presence: true
    validates :worker_kana, presence: true
    validates :worker_name, presence: true

    validates :person_id, presence: true
    validates :last_name_kana, presence: true
    validates :last_name, presence: true

    validates :original_book_title, presence: true
    validates :publisher, presence: true
    validates :first_pubdate, presence: true
    validates :input_edition, presence: true

    validate :email_is_valid

    delegate :persisted?, to: :receipt
    delegate :kana_type_name, to: :receipt
    delegate :work_status, to: :receipt

    def initialize(params = nil, receipt: Receipt.new, current_admin_user: nil)
      @receipt = receipt
      @current_admin_user = current_admin_user
      new_params = params || default_params
      super(new_params)
    end

    def email_is_valid
      errors.add(:email, :blank) if worker_id.blank? && email.blank?
    end

    def save
      return false if invalid?

      set_email

      worker = WorkerFinder.new.find_by_form(self)
      person = find_or_create_person

      result = ReceiptAssociator.new.associate_receipt(
        worker: worker,
        person: person,
        current_admin_user: current_admin_user,
        receipt_form: self
      )

      result.associated?
    rescue StandardError => e
      Rails.logger.error(e)
      nil
    end

    def to_model
      receipt
    end

    def search_similar_workers
      if worker_name.present? || worker_kana.present?
        Worker.where('name ~* ? or name_kana ~* ?', worker_name, worker_kana)
      else
        Worker.none
      end
    end

    def search_similar_people
      if last_name.present? || last_name_kana.present?
        where_str = 'last_name ~* ? or last_name_kana ~* ?'.dup
        where_params = [last_name, last_name_kana]
        if first_name.present?
          where_str += ' or first_name ~* ?'
          where_params << first_name
        end
        if first_name_kana.present?
          where_str += ' or first_name_kana ~* ?'
          where_params << first_name_kana
        end
        Person.where(where_str, *where_params)
      else
        Person.none
      end
    end

    def person_name
      Person.find(person_id).name
    end

    def work_status_name
      WorkStatus.find(work_status_id).name
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

    def find_or_create_person
      person = Person.find(person_id) if person_id
      person.presence || Person.new(
        id: person_id,
        first_name: first_name,
        first_name_kana: first_name_kana,
        first_name_en: first_name_en,
        last_name: last_name,
        last_name_kana: last_name_kana,
        last_name_en: last_name_en,
        born_on: born_on,
        died_on: died_on,
        copyright_flag: copyright_flag,
        note: person_note,
        note_user_id: current_admin_user.id
      )
    end

    def copyright_flag_name
      copyright_flag ? 'あり' : 'なし'
    end

    private

    def default_params
      {
        email: @receipt.email,
        first_appearance: @receipt.first_appearance,
        first_name: @receipt.first_name,
        first_name_en: @receipt.first_name_en,
        first_name_kana: @receipt.first_name_kana,
        first_pubdate: @receipt.first_pubdate,
        first_pubdate2: @receipt.first_pubdate2,
        input_edition: @receipt.input_edition,
        last_name: @receipt.last_name,
        last_name_en: @receipt.last_name_en,
        last_name_kana: @receipt.last_name_kana,
        memo: @receipt.memo,
        note: @receipt.note,
        original_book_note: @receipt.original_book_note,
        original_book_title: @receipt.original_book_title,
        original_book_title2: @receipt.original_book_title2,
        original_title: @receipt.original_title,
        person_note: @receipt.person_note,
        publisher: @receipt.publisher,
        publisher2: @receipt.publisher2,
        started_on: @receipt.started_on,
        subtitle: @receipt.subtitle,
        subtitle_kana: @receipt.subtitle_kana,
        title: @receipt.title,
        title_kana: @receipt.title_kana,
        url: @receipt.url,
        worker_kana: @receipt.worker_kana,
        worker_name: @receipt.worker_name,
        kana_type_id: @receipt.kana_type_id,
        person_id: @receipt.person_id,
        work_id: @receipt.work_id,
        work_status_id: @receipt.work_status_id,
        worker_id: @receipt.worker_id
      }
    end

    def set_worker_info
      if worker_id.present? && worker_id >= 0 # rubocop:disable Style/GuardClause
        worker = Worker.find(worker_id)
        self.worker_name = worker.name
        self.worker_kana = worker.name_kana
        self.email = ''
      end
    end

    def set_person_info
      if person_id.present? && person_id >= 0 # rubocop:disable Style/GuardClause
        person = Person.find(person_id)
        self.last_name = person.last_name
        self.last_name_kana = person.last_name_kana
        self.last_name_en = person.last_name_en
        self.first_name = person.first_name
        self.first_name_kana = person.first_name_kana
        self.first_name_en = person.first_name_en
        self.person_note = person.note
      end
    end

    def set_sortkey
      sortkey = convert_sortkey(title_kana) if sortkey.blank?

      if person_sortkey.blank?
        person_sortkey = convert_sortkey(last_name_kana)
        person_sortkey2 = convert_sortkey(first_name_kana)
      end
    end

    def convert_sortkey(kana)
      str = NKF.nkf('--hiragana -w', kana.to_s).dup
      str.tr!(
        'ヴがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽぁぃぅぇぉっゃゅょゎ',
        'うかきくけこさしすせそたちつてとはひふへほはひふへほあいうえおつやゆよわ'
      )
      str.gsub!(/([あかさたなはまやらわ])ー/) { "#{Regexp.last_match(1)}あ" }
      str.gsub!(/([いきしちにひみりゐ])ー/) { "#{Regexp.last_match(1)}い" }
      str.gsub!(/([うくすつぬふむゆる])ー/) { "#{Regexp.last_match(1)}う" }
      str.gsub!(/([えけせてねへめれゑ])ー/) { "#{Regexp.last_match(1)}え" }
      str.gsub!(/([おこそとのほもよろを])ー/) { "#{Regexp.last_match(1)}お" }
      str.gsub!(/[^あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをん]/, '')

      str
    end

    def set_email
      if worker_id.present? # rubocop:disable Style/GuardClause
        worker_secret = WorkerSecret.find_by(worker_id: worker_id)
        self.email = worker_secret.email
      end
    end
  end
end
