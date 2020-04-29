# frozen_string_literal: true

require "byebug"
require "dotenv/load"

require "harvest-notifier/rollbar"
require "harvest-notifier/slack"

module HarvestNotifier
  class Base
    def create_daily_report; end
  end
end
