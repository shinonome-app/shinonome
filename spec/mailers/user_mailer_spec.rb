# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer do
  describe 'register_receipt' do
    let(:receipt) { create(:receipt) }
    let(:sub_works) do
      [build(:receipt_form_sub_work)]
    end
    let(:mail) { described_class.register_receipt(receipt, sub_works) }

    it 'renders the headers' do
      expect(mail.subject).to eq('「作品その一」他の入力受付完了のお知らせ')
      expect(mail.to).to eq(['sample@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('本日、「青空文庫入力受付システム」に、以下の内容で、作品の入力申し入れがありました。')
    end
  end
end
