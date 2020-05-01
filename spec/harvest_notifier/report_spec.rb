# frozen_string_literal: true

describe HarvestNotifier::Report do
  subject(:report) { described_class.new(harvest) }

  let(:harvest) { instance_double(HarvestNotifier::Harvest) }

  before do
    allow(harvest).to receive(:users_list) { harvest_users }
  end

  describe "#daily" do
    before do
      allow(harvest).to receive(:time_report_list).with(from) { harvest_daily_time_report }
    end

    let(:from) { Date.new(2020, 4, 15) }

    let(:harvest_users) do
      {
        "users" => [
          {
            "id" => 123,
            "email" => "john.smith@example.com"
          },
          {
            "id" => 345,
            "email" => "bill.doe@example.com"
          }
        ]
      }
    end

    let(:harvest_daily_time_report) do
      {
        "results" => [
          {
            "user_id" => 123,
            "total_hours" => 6.0
          }
        ]
      }
    end

    let(:expected_resutls) do
      [
        {
          "email" => "bill.doe@example.com"
        }
      ]
    end

    it "returns daily report data" do
      Timecop.freeze(Time.local(2020, 4, 16)) do
        expect(report.daily).to eq(expected_resutls)
      end
    end
  end

  describe "#weekly" do
    before do
      allow(harvest).to receive(:time_report_list).with(from, to) { harvest_weekly_time_report }
    end

    let(:from) { Date.new(2020, 4, 13) }
    let(:to) { Date.new(2020, 4, 17) }

    let(:harvest_users) do
      {
        "users" => [
          {
            "id" => 123,
            "email" => "john.smith@example.com",
            "weekly_capacity" => 144_000
          },
          {
            "id" => 345,
            "email" => "bill.doe@example.com",
            "weekly_capacity" => 144_000
          }
        ]
      }
    end

    let(:harvest_weekly_time_report) do
      {
        "results" => [
          {
            "user_id" => 123,
            "total_hours" => 40.0
          },
          {
            "user_id" => 345,
            "total_hours" => 35.0
          }
        ]
      }
    end

    let(:expected_resutls) do
      [
        {
          "email" => "bill.doe@example.com",
          "weekly_capacity" => 40.0,
          "missing_hours" => 5.0
        }
      ]
    end

    it "returns weekly report data" do
      Timecop.freeze(Time.local(2020, 4, 20)) do
        expect(report.weekly).to eq(expected_resutls)
      end
    end
  end
end
