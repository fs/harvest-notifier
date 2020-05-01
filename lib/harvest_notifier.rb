# frozen_string_literal: true

require "byebug"
require "dotenv/load"

require "harvest-notifier/rollbar"
require "harvest-notifier/base"

module HarvestNotifier
  module_function

  def create_daily_report
    HarvestNotifier::Base.new.create_daily_report
  end

  def create_weekly_report
    HarvestNotifier::Base.new.create_weekly_report
  end
end
