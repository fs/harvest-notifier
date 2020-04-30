# frozen_string_literal: true

describe HarvestNotifier do
  let(:base_bouble) { instance_double(HarvestNotifier::Base) }

  before do
    allow(HarvestNotifier::Base)
      .to receive(:new) { base_bouble }
  end

  describe "#create_daily_report" do
    before do
      allow(base_bouble).to receive(:create_daily_report)
    end

    it "creates daily report" do
      expect(base_bouble)
        .to receive(:create_daily_report)
      expect(base_bouble)
        .not_to receive(:create_weekly_report)

      described_class.create_daily_report
    end
  end

  describe "#create_weekly_report" do
    before do
      allow(base_bouble).to receive(:create_weekly_report)
    end

    it "creates daily report" do
      expect(base_bouble)
        .to receive(:create_weekly_report)
      expect(base_bouble)
        .not_to receive(:create_daily_report)

      described_class.create_weekly_report
    end
  end
end
