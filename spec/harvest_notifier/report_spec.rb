# frozen_string_literal: true

describe HarvestNotifier::Report do
  subject(:report) { described_class.new(harvest) }
  let(:harvest) { instance_double(HarvestNotifier::Harvest) }

  before do
    allow(harvest).to receive(:users_list) { harvest_users }
    allow(harvest).to receive(:time_report_list).with(from) { harvest_time_report }
  end

  describe "#daily" do
    let(:harvest_users) do
      {
        "users" => [
          {
            "id" => 123,
            "email" => "john.smith@example.com",
          },
          {
            "id" => 345,
            "email" => "bill.doe@example.com",
          }
        ]
      }
    end

    let(:harvest_time_report) do
      {
        "results" => [
          {
            "user_id" => 123,
            "total_hours" => 6.0,
          }
        ]
      }
    end

    let(:expected_resutls) do
      [
        { "email" => "bill.doe@example.com" }
      ]
    end

    it "returns daily report data" do
      Timecop.freeze(Time.local(2020, 4, 16)) do
        expect(report.daily).to eq(expected_resutls)
      end
    end
  end
end