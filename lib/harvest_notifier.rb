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
      return unless daily_suitable?

      @from = @to = Date.yesterday
    end

    def create_weekly_report
      return unless Date.today.monday?

      @from = Date.today.beginning_of_week.last_week
      @to = @from + 4.days
    end

    def create_period_report(from, to)
      @from = from
      @to = to
    end

    private

    def daily_suitable?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end

    def time_report_list
      harvest_client.time_report_list(@from, @to)
    end

    def users_list
      harvest_client.users_list
    end

    def harvest_client
      Clients::Harvest.new(ENV["HARVEST_ACCOUNT_ID"], ENV["HARVEST_TOKEN"])
    end
  end
end
