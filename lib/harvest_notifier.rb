# frozen_string_literal: true

require "require_all"
require_all "lib"
require "httparty"
require "byebug"
require "dotenv/load"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    def create_daily_report
      return unless working_day?

      @from = @to = Date.yesterday

      filter_harvest_users.daily_report
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

    def harvest_time_report
      harvest_client.time_report_list(@from, @to)
    end

    def harvest_users
      harvest_client.users_list
    end

    def filter_harvest_users
      @filter_harvest_users ||= HarvestFilter.new(harvest_users, harvest_time_report)
    end

    def harvest_client
      @harvest_client ||= Harvest.new(ENV["HARVEST_ACCOUNT_ID"], ENV["HARVEST_TOKEN"])
    end
  end
end
