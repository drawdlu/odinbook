require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_email" do
    let(:user) { create(:user) }
    let(:mail) { described_class.with(user: user).welcome_email }

    it "renders headers" do
      expect(mail.subject).to eq("Successfully Signed Up to Odinbook!")
      expect(mail.to).to eq([ user.email ])
    end

    it "renders the welcome text" do
      expect(mail.body.decoded).to include("Welcome to OdinBook")
    end

    it "renders the username" do
      expect(mail.body.decoded).to include(user.username)
    end
  end
end
