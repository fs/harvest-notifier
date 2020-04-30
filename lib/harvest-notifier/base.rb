# frozen_string_literal: true

require "harvest-notifier/report"
require "harvest-notifier/harvest"

require "active_support/core_ext/date/calculations"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    def create_daily_report
      return unless working_day?

      Report.new(harvest_client).daily
    end

    def create_weekly_report
      return unless Date.today.monday?

      Report.new(harvest_client).weekly
    end

    private

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end

    def harvest_client
      Harvest.new(ENV["HARVEST_TOKEN"], ENV["HARVEST_ACCOUNT_ID"])
    end
  end
end
