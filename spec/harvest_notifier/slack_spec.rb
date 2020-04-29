# frozen_string_literal: true

describe HarvestNotifier::Slack do
  subject(:slack) { described_class.new(token) }

  let(:token) { "slack-token" }

  # describe "#users_list" do
  #   let(:slack_users_list) { fixture("slack_users_list") }
  #   let(:formatted_users_data) { fixture("formatted_slack_users_list") }

  #   before do
  #     stub_request(:get, "https://slack.com/api/users.list")
  #       .with(headers: { "Authorization" => "Bearer #{token}" }).to_return(body: slack_users_list.to_json)
  #   end

  #   it "return members data" do
  #     expect(slack.users_list).to eq(formatted_users_data)
  #   end
  # end

  describe "#post_message" do
    let(:message) { "Hello!" }

    before do
      stub_request(:post, "https://slack.com/api/chat.postMessage")
        .with(headers: { "Authorization" => "Bearer #{token}" }, body: message)
        .to_return(status: 200)
    end

    it "return members data" do
      expect(slack.post_message(message)).to be_success
    end
  end
end
