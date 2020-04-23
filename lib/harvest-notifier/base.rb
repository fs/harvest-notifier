# frozen_string_literal: true

require "harvest-notifier/harvest"
require "harvest-notifier/harvest_filter"

require "active_support/core_ext/date/calculations"
require "active_support/core_ext/module/delegation"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    delegate :users_list, :time_report_list, to: :harvest_client, prefix: :harvest

    def create_daily_report
      return unless working_day?

      HarvestFilter.new(harvest_users_list, harvest_time_report_list(Date.yesterday)).daily_report
    end

    def create_weekly_report
      return unless Date.today.monday?

      @from = Date.today.beginning_of_week.last_week
      @to = from + 4.days

      # wip
    end

    private

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end

    def harvest_client
      @harvest_client ||= Harvest.new(ENV["HARVEST_ACCOUNT_ID"], ENV["HARVEST_TOKEN"])
    end
  end
end
