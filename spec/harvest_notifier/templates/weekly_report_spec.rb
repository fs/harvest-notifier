# frozen_string_literal: true

describe HarvestNotifier::Templates::WeeklyReport do
  subject(:template) do
    described_class.generate(users: users, date_from: Date.new(2020, 4, 6), date_to: Date.new(2020, 4, 10))
  end

  describe "#generate" do
    let(:users) do
      [
        {
          email: "bill.doe@example.com",
          slack_id: "U02TEST",
          full_name: "Bill Doe",
          missing_hours: 2.0,
          weekly_capacity: 40.0
        }
      ]
    end

    it "generates template with mentioning users" do
      expect(template).to include("@U02TEST")
      expect(template).to include("*2.0* hours of 40.0")
    end

    context "when slack_id didn't present" do
      let(:users) do
        [
          {
            email: "bill.doe@example.com",
            slack_id: "",
            full_name: "Bill Doe",
            missing_hours: 2.0,
            weekly_capacity: 40.0
          }
        ]
      end

      it "generates template with full_name users" do
        expect(template).to include("Bill Doe")
        expect(template).to include("*2.0* hours of 40.0")
      end
    end
  end
end
