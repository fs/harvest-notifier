# frozen_string_literal: true

lib_dir = File.expand_path("lib", File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require "harvest_notifier"
require "harvest_notifier/slack_handler"

run HarvestNotifier::SlackHandler.new
