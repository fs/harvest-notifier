# frozen_string_literal: true

require "harvest-notifier/report"

require "active_support/core_ext/date/calculations"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    def create_daily_report
      return unless working_day?

      Report.new(:daily).filter_users
    end

    def create_weekly_report
      return unless Date.today.monday?

      Report.new(:weekly).filter_users
    end

    private

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end
  end
end
