# frozen_string_literal: true

require "dotenv/load"

require "harvest_notifier/rollbar"
require "harvest_notifier/base"

module HarvestNotifier
  module_function

  def create_daily_report
    return unless Date.today.on_weekday?

    HarvestNotifier::Base.new.create_daily_report(Date.yesterday)
  end

  def create_weekly_report
    return unless Date.today.monday?

    date_from = Date.today.last_week
    date_to = date_from + 4

    HarvestNotifier::Base.new.create_weekly_report(date_from, date_to)
  end
end
