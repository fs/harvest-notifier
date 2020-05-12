# frozen_string_literal: true

require "rack/test"

require "active_support/json"
require "active_support/core_ext/object/json"

require "harvest-notifier/slack_handler"

describe HarvestNotifier::SlackHandler do
  include Rack::Test::Methods

  subject(:app) { described_class.new }

  let(:response) { post "/", params }

  before do
    allow(HarvestNotifier::Report).to receive
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
          "actions" => [
            {
              "value" => "daily:2020-05-13"
            }
          ]
        }.to_json
      }
    end

    it "returns the status 200" do
      expect(response.status).to eq 200
    end

    it "returns daily report" do
      expect(response.body).to eq "Daily Report"
    end
  end
end
