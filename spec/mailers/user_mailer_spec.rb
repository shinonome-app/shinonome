require "rails_helper"

RSpec.describe UsrMailer, type: :mailer do
  describe "register_receipt" do
    let(:mail) { UsrMailer.register_receipt }

    it "renders the headers" do
      expect(mail.subject).to eq("Register receipt")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
