# frozen_string_literal: true

describe HarvestNotifier::Slack do
  subject(:slack) { described_class.new(token) }

  let(:token) { "slack-token" }

  describe "#users_list" do
    let(:slack_users_list) { fixture("slack_users_list") }
    let(:formatted_users_data) { fixture("formatted_slack_users_list") }

    before do
      stub_request(:get, "https://slack.com/api/users.list")
        .with(headers: { "Authorization" => "Bearer #{token}" }).to_return(body: slack_users_list.to_json)
    end

    it "return members data" do
      expect(slack.users_list).to eq(formatted_users_data)
    end
  end

  describe "#post_message" do
    let(:response_body) { { "ts" => "1517159293.000042" } }
    let(:response) { instance_double(HTTParty::Response, body: response_body) }
    let(:text) { "Hello World!" }

    before do
      allow(slack).to receive(:post_message).with(text).and_return(response)
    end

    it "return members data" do
      expect(slack)
        .to receive(:post_message) { response }

      slack.post_message(text)
    end
  end
end
