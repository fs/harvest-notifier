# frozen_string_literal: true

describe HarvestNotifier::Templates::Daily do
  subject(:daily) { described_class.generate(users: users) }

  describe "#generate" do
    context "when all users reported the hours" do
      let(:users) { [] }

      it "generates template what all logging the hours" do
        expect(daily).to include("Hooray, everyone reported the working hours for the previous day!")
      end
    end

    context "when some users didn't report the hours" do
      let(:users) { [{ "email" => "bill.doe@example.com", "id" => "U02TEST" }] }

      it "generates template with mentioning users" do
        expect(daily)
          .to include("Here is a list of people who didn't report the working hours for the previous day: <@U02TEST>")
      end
    end
  end
end
