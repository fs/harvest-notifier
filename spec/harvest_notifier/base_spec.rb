# frozen_string_literal: true

describe HarvestNotifier::Base do
  subject(:base) { described_class.new }

  let(:report_double) { instance_double(HarvestNotifier::Report) }
  let(:harvest_double) { instance_double(HarvestNotifier::Harvest) }
  let(:slack_double) { instance_double(HarvestNotifier::Slack) }
  let(:notification_double) { instance_double(HarvestNotifier::Notification) }

  let(:users_data) do
    [
      {
        email: "john.smith@example.com",
        weekly_capacity: 144_000,
        slack_id: "U01TEST",
        missing_hours: 2.0
      },
      {
        email: "bill.doe@example.com",
        weekly_capacity: 144_000,
        slack_id: "U02TEST",
        missing_hours: 5.0
      }
    ]
  end

  before do
    allow(HarvestNotifier::Harvest).to receive(:new) { harvest_double }
    allow(HarvestNotifier::Slack).to receive(:new) { slack_double }
    allow(HarvestNotifier::Report).to receive(:new).with(harvest_double, slack_double) { report_double }
    allow(HarvestNotifier::Notification).to receive(:new).with(slack_double, update_url: nil) { notification_double }

    allow(report_double).to receive(:daily) { users_data }
    allow(report_double).to receive(:weekly) { users_data }
    allow(notification_double).to receive(:deliver)
  end

  describe "#create_daily_report" do
    it "creates daily notification" do
      expect(report_double).to receive(:daily) { users_data }
      expect(notification_double).to receive(:deliver)
        .with(:daily_report, users: users_data, date: Date.new(2020, 4, 15))

      base.create_daily_report(Date.new(2020, 4, 15))
    end
  end

  describe "#create_weekly_report" do
    it "creates weekly notification" do
      expect(report_double).to receive(:weekly) { users_data }
      expect(notification_double).to receive(:deliver)
        .with(:weekly_report, users: users_data, date_from: Date.new(2020, 4, 6), date_to: Date.new(2020, 4, 10))

      base.create_weekly_report(Date.new(2020, 4, 6), Date.new(2020, 4, 10))
    end
  end
end
