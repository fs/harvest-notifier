# frozen_string_literal: true

describe HarvestNotifier do
  let(:slack_double) { instance_double(HarvestNotifier::Slack) }
  let(:harvest_filter_double) { instance_double(HarvestNotifier::HarvestFilter) }

  let(:harvest_daily_time_report) { fixture("harvest_daily_time_report") }
  let(:harvest_weekly_time_report) { fixture("harvest_weekly_time_report") }
  let(:harvest_users_list) { fixture("harvest_users_list") }
  let(:emails_data) { ["john.smith@example.com, bill.doe@example.com"] }

  before do
    allow(HarvestNotifier::HarvestFilter)
      .to receive(:new).with(type) { harvest_filter_double }
    allow(harvest_filter_double).to receive(:filter_users)
  end

  describe "notification create" do
    context "when daily report" do
      let(:harvest_time_report) { harvest_daily_time_report }
      let(:type) { :daily }

      it "creates daily notification" do
        expect(harvest_filter_double)
          .to receive(:filter_users) { emails_data }

        described_class.create_report(type)
      end
    end
  end
end
