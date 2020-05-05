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
      let(:users) { [{ "email" => "bill.doe@example.com", "id" => "U02TEST" }] }

      it "generates template with mentioning users" do
        expect(weekly)
          .to include("Here is a list of people who didn't report the working hours for the previous week: <@U02TEST>")
      end
    end
  end
end
