# frozen_string_literal: true

require "rack/test"

require "active_support/json"
require "active_support/core_ext/object/json"

require "harvest-notifier/slack_handler"

describe HarvestNotifier::SlackHandler do
  include Rack::Test::Methods

  def do_post
    post "/", params
  end

  subject(:app) { described_class.new }

  let(:response) { do_post }
  let(:base_bouble) { instance_double(HarvestNotifier::Base) }

  before do
    allow(HarvestNotifier::Base).to receive(:new) { base_bouble }

    allow(base_bouble).to receive(:create_daily_report)
    allow(base_bouble).to receive(:create_weekly_report)
  end

  context "without payload param" do
    let(:params) { "" }

    it "returns the status 422" do
      expect(response.status).to eq 422
    end
  end

  context "with invalid json in payload" do
    let(:params) { { "payload" => "[" } }

    it "returns the status 422" do
      expect(response.status).to eq 422
    end
  end

  context "with refresh daily payload in params" do
    let(:params) do
      {
        "payload" => {
          "response_url" => "https://hook.slack.com",
          "actions" => [
            {
              "value" => "daily:2020-05-13"
            }
          ]
        }.to_json
      }
    end

    it "updates daily notification by response_url" do
      expect(base_bouble)
        .to receive(:create_daily_report).with(Date.new(2020, 5, 13))
      do_post
    end

    it "returns the status 200" do
      expect(response.status).to eq 200
    end
  end

  context "with refresh weekly payload in params" do
    let(:params) do
      {
        "payload" => {
          "response_url" => "https://hook.slack.com",
          "actions" => [
            {
              "value" => "weekly:2020-05-04:2020-05-08"
            }
          ]
        }.to_json
      }
    end

    it "updates weekly notification by response_url" do
      expect(base_bouble)
        .to receive(:create_weekly_report).with(Date.new(2020, 5, 4), Date.new(2020, 5, 8))
      do_post
    end

    it "returns the status 200" do
      expect(response.status).to eq 200
    end
  end
end
