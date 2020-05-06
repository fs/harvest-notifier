# frozen_string_literal: true

describe HarvestNotifier::Templates::Congratulation do
  subject(:template) { described_class.generate }

  describe "#generate" do
    it "generates template with Congratulation" do
      expect(template).to include("Hooray")
    end
  end
end
