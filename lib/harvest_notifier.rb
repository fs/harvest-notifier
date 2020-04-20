# frozen_string_literal: true

require "require_all"
require_all "lib"
require "httparty"
require "byebug"
require "dotenv/load"

module HarvestNotifier
  class Base
    extend Forwardable

    def_delegators :harvest_client, :users_list

    def create_daily_report
      @from = @to = Date.yesterday + 1
    end

    def create_weekly_report
      @from = Date.beginning_of_week
      @to = Date.today.end_of_week - 2
    end

    def create_period_report(from, to)
      @from = from
      @to = to
    end

    private

    def time_report_list
      harvest_client.time_report_list(@from, @to)
    end

    def users_list
      harvest_client.users_list
    end

    def harvest_client
      @harvest_client ||= Clients::Harvest.new(ENV["HARVEST_ACCOUNT_ID"], ENV["HARVEST_TOKEN"])
    end
  end
end
