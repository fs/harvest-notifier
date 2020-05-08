# frozen_string_literal: true

require "active_support/core_ext/date/calculations"

require "harvest-notifier/report"
require "harvest-notifier/notification"
require "harvest-notifier/harvest"
require "harvest-notifier/slack"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    attr_reader :harvest_client, :slack_client, :notification, :report

    def initialize
      @harvest_client = Harvest.new(ENV.fetch("HARVEST_TOKEN"), ENV.fetch("HARVEST_ACCOUNT_ID"))
      @slack_client = Slack.new(ENV.fetch("SLACK_TOKEN"))

      @notification = Notification.new(slack_client)
      @report = Report.new(harvest_client)
    end

    def create_daily_report
      return unless working_day?

      users = report.daily

      if users.empty?
        notification.deliver(:congratulation)
      else
        notification.deliver(:daily_report, users: users, date: Date.yesterday)
      end
    end

    def create_weekly_report
      return unless Date.today.monday?

      users = report.weekly

      if users.empty?
        notification.deliver(:congratulation)
      else
        notification.deliver(:weekly_report, users: users)
      end
    end

    private

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end
  end
end
