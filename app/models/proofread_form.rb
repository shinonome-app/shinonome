# frozen_string_literal: true

# 校正受付システム登録用Form Object
class ProofreadForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 底本コピー、プリントアウト等入力用
  class SubWork
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :work_id, :integer
    attribute :work_copy, :integer
    attribute :work_print, :integer
    attribute :proof_edition, :string

    validates :work_id, presence: true

    delegate :title, :subtitle, :first_teihon,
             :kana_type, :translator_text, :inputer_text,
             :work_status, :started_on, :workfile,
             to: :work

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
  attribute :worker_id, :integer

  validates :worker_name, presence: true
  validates :worker_kana, presence: true
  validates :email, presence: true

  attr_accessor :sub_works

  def sub_works_attributes=(attributes)
    @sub_works ||= []
    attributes.each do |_i, sub_work_params|
      @sub_works.push(SubWork.new(sub_work_params)) if sub_work_params[:work_id].to_i > 0
    end
  end
end
