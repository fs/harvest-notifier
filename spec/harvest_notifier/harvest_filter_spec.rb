# frozen_string_literal: true

describe HarvestNotifier::HarvestFilter do
  subject(:harvest_notifier) { described_class.new(type) }

  let(:harvest_double) { instance_double(HarvestNotifier::Harvest) }

  let(:harvest_token) { "harvest-token" }
  let(:harvest_account_id) { "12345" }

  let(:harvest_daily_time_report) { fixture("harvest_daily_time_report") }
  let(:harvest_weekly_time_report) { fixture("harvest_weekly_time_report") }
  let(:harvest_users_list) { fixture("harvest_users_list") }
  let(:result_data) { [{ email: "emma.johnson@example.com" }] }

  before do
    allow(HarvestNotifier::Harvest)
      .to receive(:new).with(harvest_token, harvest_account_id) { harvest_double }
    allow(harvest_double).to receive(:users_list) { harvest_users_list }
    allow(harvest_double).to receive(:time_report_list).with(from) { harvest_time_report }
  end

  describe "#filter_users" do
    context "when daily type" do
      before do
        Timecop.freeze(Time.local(2020, 4, 16))
      end

      after do
        Timecop.return
      end

      let(:type) { :daily }
      let(:from) { Date.new(2020, 4, 15) }

      let(:harvest_time_report) { harvest_daily_time_report }

      it "receive data from Harvest" do
        expect(harvest_double)
          .to receive(:users_list) { harvest_users_list }
        expect(harvest_double)
          .to receive(:time_report_list) { harvest_time_report }

        harvest_notifier.filter_users
      end

      it "create daily report" do
        expect(harvest_notifier.filter_users).to eq(result_data)
      end
    end
  end
end
