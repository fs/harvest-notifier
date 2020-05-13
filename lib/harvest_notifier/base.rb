# frozen_string_literal: true

require "active_support/core_ext/date/calculations"
require "active_support/core_ext/date_and_time/calculations"

require "harvest_notifier/report"
require "harvest_notifier/notification"
require "harvest_notifier/harvest"
require "harvest_notifier/slack"

module HarvestNotifier
  class Base
    attr_reader :harvest_client, :slack_client, :notification, :report

    def initialize(notification_update_url: nil)
      @harvest_client = Harvest.new(ENV.fetch("HARVEST_TOKEN"), ENV.fetch("HARVEST_ACCOUNT_ID"))
      @slack_client = Slack.new(ENV.fetch("SLACK_TOKEN"))

      @notification = Notification.new(slack_client, update_url: notification_update_url)
      @report = Report.new(harvest_client, slack_client)
    end

    def create_daily_report(date)
      users = report.daily(date)

      if users.empty?
        notification.deliver :congratulation
      else
        notification.deliver :daily_report, users: users, date: date
      end
    end

    def create_weekly_report(date_from, date_to)
      users = report.weekly(date_from, date_to)

      if users.empty?
        notification.deliver :congratulation
      else
        notification.deliver :weekly_report, users: users, date_from: date_from, date_to: date_to
      end
    end
  end
end
