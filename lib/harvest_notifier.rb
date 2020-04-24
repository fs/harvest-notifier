# frozen_string_literal: true

require "byebug"
require "dotenv/load"

require "harvest-notifier/rollbar"
require "harvest-notifier/slack"
require "harvest-notifier/slack_sender"
require "harvest-notifier/templates/daily"
require "harvest-notifier/templates/weekly"

module HarvestNotifier
  class Base
    def create_daily_report
      users_data = ["vadim.kurnatovskiy@flatstack.com"]

      SlackSender.new(users_data, HarvestNotifier::Templates::Daily).notify
    end
  end
end
