require 'rails_helper'

RSpec.describe PostsChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end
  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
  end
end
