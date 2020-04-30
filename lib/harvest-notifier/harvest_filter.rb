# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

require "harvest-notifier/harvest"

module HarvestNotifier
  class HarvestFilter
    attr_reader :from, :to, :type

    delegate :users_list, :time_report_list, to: :harvest_client, prefix: :harvest

    def initialize(type)
      @type = type
    end

    def filter_users
      case type
      when :daily
        daily_report
      when :weekly
        weekly_report
      end
    end

    private

    def daily_report
      @from = Date.yesterday

      users = daily_filter_users

      users.map do |u|
        {
          email: u["email"]
        }
      end
    end

    def weekly_report
      # @from = Date.today.last_week
      # @to = @from + 4.days
      # users = weekly_filter_users

      # users.map do |u|
      #   {
      #     email: u[:email],
      #     missing_hours: u[:missing_hours]
      #   }
      # end
    end

    def daily_filter_users
      harvest_users_list["users"].reject do |user|
        time_report_user_ids.include?(user["id"]) || emails_whitelist.include?(user["email"])
      end
    end

    def time_report_user_ids
      @time_report_user_ids ||= harvest_time_report_list(from)["results"].map { |r| r["user_id"] }
    end

    def harvest_client
      @harvest_client ||= Harvest.new(ENV["HARVEST_TOKEN"], ENV["HARVEST_ACCOUNT_ID"])
    end

    def emails_whitelist
      ENV["EMAILS_WHITELIST"].split(",").map(&:strip)
    end
  end
end
