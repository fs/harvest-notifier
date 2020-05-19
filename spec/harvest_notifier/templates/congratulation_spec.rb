# frozen_string_literal: true

describe HarvestNotifier::Templates::Congratulation do
  subject(:template) { described_class }

  describe "#generate" do
    context "when daily report" do
      let(:date) { Date.new(2020, 4, 9) }

      it "generates template with Congratulation" do
        expect(template.generate(date: date))
          .to include("Hooray, everyone reported the working hours for *April 9th*!")
      end
    end

    context "when weekly report" do
      let(:date_from) { Date.new(2020, 4, 6) }
      let(:date_to) { Date.new(2020, 4, 10) }

      it "generates template with Congratulation" do
        expect(template.generate(date_from: date_from, date_to: date_to))
          .to include("Hooray, everyone reported the working hours for *06 Apr - 10 Apr 2020*!")
      end
    end
  end
end
