# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'register_receipt' do
    let(:mail) { described_class.register_receipt }

    it 'renders the headers' do # rubocop:disable RSpec/MultipleExpectations
      expect(mail.subject).to eq('Register receipt')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
