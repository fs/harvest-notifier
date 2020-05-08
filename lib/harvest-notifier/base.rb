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

    delegate :users_list, to: :slack_client, prefix: :slack

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
        notification.deliver(:daily_report, users: with_slack_mention(users), date: Date.yesterday)
      end
    end

    def create_weekly_report
      return unless Date.today.monday?

      users = report.weekly

      if users.empty?
        notification.deliver(:congratulation)
      else
        notification.deliver(:weekly_report, users: with_slack_mention(users))
      end
    end

    private

    def with_slack_mention(users)
      users.each do |user|
        slack_id = slack_users.find { |u| u["profile"]["email"] == user[:email] }["id"]

        user[:slack_id] = slack_id
      end
    end

    def slack_users
      @slack_users ||= slack_users_list["members"]
    end

    def working_day?
      DAILY_REPORT.include?(Date.today.strftime("%A"))
    end
  end
end
