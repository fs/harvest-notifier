# frozen_string_literal: true

require "byebug"
require "rollbar"
require "harvest-notifier/base"
require "harvest-notifier/slack"
require "harvest-notifier/harvest"

module HarvestNotifier
  module_function

  def create_report(type)
    HarvestNotifier::Base.new.public_send("create_#{type}_report")
  end
end
