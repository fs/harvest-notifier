# frozen_string_literal: true

describe HarvestNotifier::Report do
  subject(:report) { described_class.new(harvest) }

  let(:harvest) { instance_double(HarvestNotifier::Harvest) }

  let(:john_doe) do
    {
      "id" => 123,
      "email" => "john.smith@example.com",
      "weekly_capacity" => 144_000
    }
  end

  let(:bill_doe) do
    {
      "id" => 345,
      "email" => "bill.doe@example.com",
      "weekly_capacity" => 144_000
    }
  end

  let(:harvest_users) do
    {
      "users" => [john_doe, bill_doe]
    }
  end

  before do
    allow(harvest).to receive(:users_list) { harvest_users }
    allow(harvest).to receive(:time_report_list) { harvest_time_report }
  end

  describe "#daily" do
    let(:harvest_time_report) do
      {
        "results" => [
          {
            "user_id" => john_doe["id"],
            "total_hours" => 6.0
          }
        ]
      }
    end

    around do |ex|
      Timecop.freeze(Time.local(2020, 4, 16)) { ex.run }
    end

    it "returns Bill Doe without time reports" do
      expect(report.daily).to include(bill_doe["email"])
    end

    it "does not return John Doe with time report" do
      expect(report.daily).not_to include(john_doe["email"])
    end
  end

  describe "#weekly" do
    let(:harvest_time_report) do
      {
        "results" => [
          {
            "user_id" => john_doe["id"],
            "total_hours" => 39.0
          },
          {
            "user_id" => bill_doe["id"],
            "total_hours" => 35.0
          }
        ]
      }
    end

    around do |ex|
      Timecop.freeze(Time.local(2020, 4, 20)) { ex.run }
    end

    it "returns Bill Does with missing 5 hours" do
      expect(report.weekly).to include(bill_doe["email"])
      expect(report.weekly[bill_doe["email"]]).to include("missing_hours" => 5.0)
    end

    it "does not return John Doe with missing 1 hour b/c of threshold default 1.0 hour" do
      expect(report.weekly).not_to include(john_doe["email"])
    end
  end
end
