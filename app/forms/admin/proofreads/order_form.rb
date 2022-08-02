# frozen_string_literal: true

module Admin
  module Proofreads
    # 校正受付システム管理画面発注用Form Object
    class OrderForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations::Callbacks

      attr_reader :proofread

      attribute :work_id, :integer
      attribute :mail_memo, :string

      validates :work_id, presence: true
      validates :mail_memo, presence: true

      def initialize(params = nil, proofread: Proofread.new)
        @proofread = proofread
        new_params = params || default_params
        super(new_params)
      end

      def send!
        Proofread.transaction do
          proofread.ordered!
          work = proofread.work
          work.work_status_id = 9
          work.save!
        end
        ProofreadOrderSender.new.send(proofread: proofread, mail_memo: mail_memo)
      end

      private

      def default_params
        {
          mail_memo: ''
        }
      end
    end
  end
end
