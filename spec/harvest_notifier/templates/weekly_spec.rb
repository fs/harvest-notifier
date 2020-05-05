# frozen_string_literal: true

describe HarvestNotifier::Templates::Weekly do
  subject(:weekly) { described_class.generate(users: users) }

  describe "#generate" do
    context "when all users reported the hours" do
      let(:users) { [] }

      it "generates template what all logging the hours" do
        expect(weekly).to include("Hooray, everyone reported the working hours for the previous week!")
      end
    end

    context "when some users didn't report the hours" do
      let(:users) do
        [
          { "email" => "bill.doe@example.com",
            "id" => "U02TEST",
            "missing_hours" => 2.0,
            "weekly_capacity" => 40.0
          },
          { "email" => "john.smith@example.com",
            "id" => "U01TEST",
            "missing_hours" => 5.0,
            "weekly_capacity" => 35.0
          },
        ]
      end

      it "generates template with mentioning users" do
        expect(weekly)
          .to include("<@U02TEST> did not send 2.0* hours out of 40.0 hours")
      end
    end
  end
end
