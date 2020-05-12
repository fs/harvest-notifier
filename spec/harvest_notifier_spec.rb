# frozen_string_literal: true

describe HarvestNotifier do
  let(:base_bouble) { instance_double(HarvestNotifier::Base) }

  before do
    allow(HarvestNotifier::Base).to receive(:new) { base_bouble }

    allow(base_bouble).to receive(:create_daily_report)
    allow(base_bouble).to receive(:create_weekly_report)
  end

  describe "#create_daily_report" do
    it "creates daily report" do
      Timecop.freeze(Date.new(2020, 4, 16)) do
        expect(base_bouble).to receive(:create_daily_report)
        described_class.create_daily_report
      end
    end

    it "does not create daily report on Sat (April 18, 2020)" do
      Timecop.freeze(Date.new(2020, 4, 18)) do
        expect(base_bouble).not_to receive(:create_daily_report)
        described_class.create_daily_report
      end
    end
  end

  describe "#create_weekly_report" do
    it "creates weekly report" do
      Timecop.freeze(Date.new(2020, 4, 13)) do
        expect(base_bouble).to receive(:create_weekly_report)
        described_class.create_weekly_report
      end
    end

    it "does not create weekly report workday except Monday" do
      Timecop.freeze(Date.new(2020, 4, 14)) do
        expect(base_bouble).not_to receive(:create_weekly_report)
        described_class.create_weekly_report
      end
    end
  end
end
