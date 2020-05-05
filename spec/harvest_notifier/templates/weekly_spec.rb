# frozen_string_literal: true

describe HarvestNotifier::Templates::Weekly do
  subject(:weekly) { described_class.generate(users: users) }

  describe "#generate" do
    context "when all users reported the hours" do
      let(:users) { [] }

      it "generates template what all logging the hours" do
        expect(weekly).to include("Ура, все отметили часы за предыдущую неделю!")
      end
    end

    context "when some users didn't report the hours" do
      let(:users) { [{ "email" => "bill.doe@example.com", "id" => "U02TEST" }] }

      it "generates template with mentioning users" do
        expect(weekly).to include("Вот список людей, кто не отправил часы за предыдущую неделю: <@U02TEST>")
      end
    end
  end
end
