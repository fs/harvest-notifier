# frozen_string_literal: true

describe HarvestNotifier do
  let(:harvest_double) { instance_double(HarvestNotifier::Harvest) }
  let(:slack_double) { instance_double(HarvestNotifier::Slack) }
  let(:harvest_filter_double) { instance_double(HarvestNotifier::HarvestFilter) }

  let(:harvest_daily_time_report) { fixture("harvest_daily_time_report") }
  let(:harvest_weekly_time_report) { fixture("harvest_weekly_time_report") }
  let(:harvest_users_list) { fixture("harvest_users_list") }
  let(:emails_data) { ["john.smith@example.com, bill.doe@example.com"] }

  before do
    allow(HarvestNotifier::Harvest).to receive(:new).with("12345", "harvest-token") { harvest_double }
    allow(HarvestNotifier::HarvestFilter)
      .to receive(:new).with(harvest_users_list, harvest_time_report) { harvest_filter_double }
    allow(harvest_filter_double).to receive(:daily_report)
    allow(harvest_double).to receive(:users_list)
    allow(harvest_double).to receive(:time_report_list).with(from, to)
  end

  describe "notification create" do
    context "when daily report" do
      let(:harvest_time_report) { harvest_daily_time_report }
      let(:from) { Timecop.freeze("2020-04-15") }
      let(:to) { Timecop.freeze("2020-04-15") }

      it "creates daily notification" do
        expect(harvest_double)
          .to receive(:time_report_list) { harvest_time_report }
        expect(harvest_double)
          .to receive(:users_list) { harvest_users_list }

        described_class.create_daily_report
      end
    end
  end
end
