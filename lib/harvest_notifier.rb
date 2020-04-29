# frozen_string_literal: true

require "byebug"
require "dotenv/load"
require "rollbar"
require "harvest-notifier/base"
require "harvest-notifier/slack"

module HarvestNotifier
  module_function

  def create_report(type)
    HarvestNotifier::Base.new.public_send("create_#{type}_report")
  end
end
