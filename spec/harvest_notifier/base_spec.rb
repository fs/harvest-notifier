# frozen_string_literal: true

describe HarvestNotifier::Base do
  subject(:base) { described_class.new }

  let(:report_double) { instance_double(HarvestNotifier::Report) }
  let(:harvest_double) { instance_double(HarvestNotifier::Harvest) }
  let(:slack_double) { instance_double(HarvestNotifier::Slack) }
  let(:notification_double) { instance_double(HarvestNotifier::Notification) }

  let(:users_data) do
    [
      { "email" => "bill.doe@example.com" }
    ]
  end

  before do
    allow(HarvestNotifier::Harvest).to receive(:new) { harvest_double }
    allow(HarvestNotifier::Slack).to receive(:new) { slack_double }
    allow(HarvestNotifier::Report).to receive(:new).with(harvest_double) { report_double }
    allow(HarvestNotifier::Notification).to receive(:new).with(slack_double) { notification_double }

    allow(report_double).to receive(:daily) { users_data }
    allow(report_double).to receive(:weekly) { users_data }
    allow(notification_double).to receive(:deliver)
  end

  describe "#create_daily_report" do
    it "creates daily notification" do
      Timecop.freeze(Date.new(2020, 4, 16)) do
        expect(report_double).to receive(:daily) { users_data }
        expect(notification_double).to receive(:deliver)
          .with(:daily_report, users: users_data, date: Date.new(2020, 4, 15))

        base.create_daily_report
      end
    end

    it "does not create daily notification" do
      Timecop.freeze(Date.new(2020, 4, 18)) do
        expect(report_double).not_to receive(:daily)
        expect(notification_double).not_to receive(:deliver)

        base.create_daily_report
      end
    end
  end

  describe "#create_weekly_report" do
    it "creates weekly notification" do
      Timecop.freeze(Date.new(2020, 4, 13)) do
        expect(report_double).to receive(:weekly) { users_data }
        expect(notification_double).to receive(:deliver)
          .with(:weekly_report, users: users_data, week_from: Date.new(2020, 4, 6), week_to: Date.new(2020, 4, 10))

        base.create_weekly_report
      end
    end

    it "does not create weekly notification" do
      Timecop.freeze(Date.new(2020, 4, 14)) do
        expect(report_double).not_to receive(:weekly)
        expect(notification_double).not_to receive(:deliver).with(:weekly_report, users: users_data)

        base.create_weekly_report
      end
    end
  end
end
