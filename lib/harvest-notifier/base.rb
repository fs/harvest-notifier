# frozen_string_literal: true

require "active_support/core_ext/date/calculations"

require "harvest-notifier/report"
require "harvest-notifier/notification"
require "harvest-notifier/harvest"
require "harvest-notifier/slack"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    def create_daily_report
      return unless working_day?

      users = Report.new(harvest_client).daily
      notification = Notification.new(slack_client, users: users)

      if users.empty?
        notification.deliver(:congratulation)
      else
        notification.deliver(:daily_report)
      end
    end

    def create_weekly_report
      return unless Date.today.monday?

      users = Report.new(harvest_client).weekly
      notification = Notification.new(slack_client, users: users)

      if users.empty?
        notification.deliver(:congratulation)
      else
        notification.deliver(:weekly_report)
      end
    end

    private

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end

    def harvest_client
      Harvest.new(ENV.fetch("HARVEST_TOKEN"), ENV.fetch("HARVEST_ACCOUNT_ID"))
    end

    def slack_client
      Slack.new(ENV.fetch("SLACK_TOKEN"))
    end
  end
end
