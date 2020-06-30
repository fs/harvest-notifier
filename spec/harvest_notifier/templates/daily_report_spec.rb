# frozen_string_literal: true

describe HarvestNotifier::Templates::DailyReport do
  subject(:template) { described_class.generate(users: users, date: Date.yesterday) }

  describe "#generate" do
    let(:users) { [{ email: "bill.doe@example.com", slack_id: "U02TEST", full_name: "Bill Doe" }] }

    it "generates template with mentioning users" do
      expect(template).to include("Here is a list of people")
      expect(template).to include("@U02TEST")
    end

    context "when slack_id didn't present" do
      let(:users) { [{ email: "bill.doe@example.com", slack_id: "", full_name: "Bill Doe" }] }

      it "generates template with full_name users" do
        expect(template).to include("Here is a list of people")
        expect(template).to include("Bill Doe")
      end
    end
  end
end
