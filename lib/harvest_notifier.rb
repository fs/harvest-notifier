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
      # weekly_users_data = [{email: "vadim.kurnatovskiy@flatstack.com", missing_hours: 4},
      #              {email: "example@flatstack.com", missing_hours: 8}]

      users_data = [{ email: "vadim.kurnatovskiy@flatstack.com" }, { email: "example@flatstack.com" }]

      SlackSender.new(users_data, HarvestNotifier::Templates::Daily).notify
    end
  end
end
