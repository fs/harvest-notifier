# frozen_string_literal: true

lib_dir = File.expand_path("lib", File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require "dotenv/load"
require "snitcher"
require "harvest_notifier"

namespace :reports do
  desc "This task send report for the last week"
  task :weekly do
    Snitcher.snitch(ENV["SNITCH_DAILY"]) if ENV["SNITCH_DAILY"]
  end

  desc "This task send report for the past day"
  task :daily do
    HarvestNotifier.create_report(:daily)
    Snitcher.snitch(ENV["SNITCH_DAILY"]) if ENV["SNITCH_DAILY"]
  end
end
