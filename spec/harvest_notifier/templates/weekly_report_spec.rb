# frozen_string_literal: true

describe HarvestNotifier::Templates::WeeklyReport do
  subject(:template) { described_class.generate(users: users) }

  describe "#generate" do
    let(:users) do
      [
        {
          "email" => "bill.doe@example.com",
          "id" => "U02TEST",
          "missing_hours" => 2.0,
          "weekly_capacity" => 40.0
        }
      ]
    end

    it "generates template with mentioning users" do
      expect(template).to include("bill.doe@example.com didn't send 2.0* hours out of 40.0 hours")
    end
  end
end
