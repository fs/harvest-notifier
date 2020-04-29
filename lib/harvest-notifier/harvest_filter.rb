# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

require "harvest-notifier/harvest"

module HarvestNotifier
  class HarvestFilter
    attr_reader :from, :to, :type

    delegate :users_list, :time_report_list, to: :harvest_client, prefix: :harvest

    def initialize(type)
      case type
      when :daily
        daily_initialize
      when :weekly
        weekly_initialize
      end
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
      users = daily_filter_users

      users.map do |u|
        {
          email: u[:email]
        }
      end
    end

    def weekly_report
      users = weekly_filter_users

      users.map do |u|
        {
          email: u[:email],
          missing_hours: u[:missing_hours]
        }
      end
    end

    def daily_initialize
      @from = Date.yesterday
      @to = @from
    end

    def weekly_initialize
      @from = Date.today.last_week
      @to = @from + 4.days
    end

    def daily_filter_users
      harvest_users_list.reject do |user|
        time_report_user_ids.include?(user[:id]) || emails_whitelist.include?(user[:email])
      end
    end

    def weekly_filter_users
      users_list_with_time.reject do |user|
        emails_whitelist.include?(user[:email])
      end
    end

    def time_report_user_ids
      @time_report_user_ids ||= harvest_time_report_list(from, to).map { |r| r[:user_id] }
    end

    def harvest_client
      @harvest_client ||= Harvest.new(ENV["HARVEST_ACCOUNT_ID"], ENV["HARVEST_TOKEN"])
    end

    def emails_whitelist
      ENV["EMAILS_WHITELIST"].split(",").map(&:strip)
    end
  end
end
