# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'register_receipt' do
    let(:receipt) { create(:receipt) }
    let(:booklist) do
      "作品名　　　　　：#{receipt.title}\n" +
        "文字遣い種別　　：#{receipt.kana_type&.name}\n"
    end
    let(:mail) { described_class.register_receipt(receipt, booklist) }

    it 'renders the headers' do # rubocop:disable RSpec/MultipleExpectations
      expect(mail.subject).to eq('Register receipt')
      expect(mail.to).to eq(['takahashimm+admin@gmail.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('本日、「青空文庫入力受付システム」に、以下の内容で、作品の入力申し入れがありました。')
    end
  end
end
