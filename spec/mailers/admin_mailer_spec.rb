# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminMailer do
  describe 'order_receipt' do
    let(:worker_secret) { create(:worker_secret, email: 'to@example.com') }
    let(:worker) { worker_secret.worker }
    let(:receipt) do
      create(:receipt, :work, worker: worker) do |receipt|
        create(:original_book, work: receipt.work, booktype_id: 1)
      end
    end
    let(:mail) { AdminMailer.order_receipt(receipt) }

    it 'renders the headers' do
      expect(mail.subject).to eq("「#{receipt.title} #{receipt.subtitle}」入力のお願い")
      expect(mail.to).to eq(['to@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('青空文庫は、以下の内容で入力申し入れのあった作品を、入力していただけることを確認しました。')
    end
  end
end
