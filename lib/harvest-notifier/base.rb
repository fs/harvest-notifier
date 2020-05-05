# frozen_string_literal: true

require "active_support/core_ext/date/calculations"

require "harvest-notifier/report"
require "harvest-notifier/notification"
require "harvest-notifier/harvest"
require "harvest-notifier/slack"
require "harvest-notifier/templates/daily"
require "harvest-notifier/templates/weekly"

module HarvestNotifier
  class Base
    DAILY_REPORT = %w[Tuesday Wednesday Thursday Friday].freeze

    def create_daily_report
      return unless working_day?

      users = Report.new(harvest_client).daily

      Notification.new(slack_client, users, HarvestNotifier::Templates::Daily).deliver
    end

    def create_weekly_report
      return unless Date.today.monday?

      users = Report.new(harvest_client).weekly

      Notification.new(slack_client, users, HarvestNotifier::Templates::Weekly).deliver
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
