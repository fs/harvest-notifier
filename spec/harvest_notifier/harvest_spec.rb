# frozen_string_literal: true

describe HarvestNotifier::Harvest do
  subject(:harvest) { described_class.new(token, account_id) }

  let(:token) { "harvest-token" }
  let(:account_id) { "12345" }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Harvest-Account-Id" => account_id } }

  describe "#users_list" do
    let(:harvest_users_list) { fixture("harvest_users_list") }

    before do
      stub_request(:get, "https://api.harvestapp.com/api/v2/users.json?is_active=true")
        .with(headers: headers)
        .to_return(body: harvest_users_list.to_json)
    end

    it "success" do
      expect(harvest.users_list).to be_success
    end

    it "returns user list" do
      expect(harvest.users_list).to include("users")
    end
  end

  describe "#time_report_list" do
    let(:query) { "?from=#{from.strftime('%Y%m%d')}&to=#{to.strftime('%Y%m%d')}" }

    before do
      stub_request(:get, "https://api.harvestapp.com/api/v2/reports/time/team.json#{query}")
        .with(headers: headers)
        .to_return(body: time_report_list.to_json)
    end

    context "when daily time report" do
      let(:from) { Date.new(2020, 4, 15) }
      let(:to) { Date.new(2020, 4, 15) }

      let(:time_report_list) { fixture("harvest_daily_time_report") }

      it "success" do
        expect(harvest.time_report_list(from, to)).to be_success
      end

      it "returns daily report" do
        expect(harvest.time_report_list(from, to)).to include("results")
      end
    end

    context "when weekly time report" do
      let(:from) { Date.new(2020, 4, 13) }
      let(:to) { Date.new(2020, 4, 17) }

      let(:time_report_list) { fixture("harvest_weekly_time_report") }

      it "success" do
        expect(harvest.time_report_list(from, to)).to be_success
      end

      it "returns weekly report" do
        expect(harvest.time_report_list(from, to)).to include("results")
      end
    end
  end
end
