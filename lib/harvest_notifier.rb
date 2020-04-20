# frozen_string_literal: true

require "harvest-notifier/rollbar"
require "harvest-notifier/slack"

module HarvestNotifier
  class Base
    def initialize; end

    def create_daily_report; end
  end
end
