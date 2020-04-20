# frozen_string_literal: true

lib_dir = File.expand_path("lib", File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require "dotenv/load"
require "snitcher"

namespace :reports do
  desc "This task send weekly report about users who forgot to mark their working hours in Harvest"
  task :weekly do
    Snitcher.snitch(ENV["SNITCH_DAILY"]) if ENV["SNITCH_DAILY"]
  end

  desc "This task send report for the past day"
  task :daily do
    HarvestNotifier::Base.new.create_daily_report
    Snitcher.snitch(ENV["SNITCH_DAILY"]) if ENV["SNITCH_DAILY"]
  end
end
