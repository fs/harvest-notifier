# frozen_string_literal: true

require "httparty"
require "active_support/core_ext/object/to_query"

module HarvestNotifier
  class Harvest
    include HTTParty

    base_uri "https://api.harvestapp.com/api/v2"
    logger ::Logger.new STDOUT

    def initialize(token, account_id)
      headers = { "Authorization" => "Bearer #{token}", "Harvest-Account-Id" => account_id }
      self.class.headers headers
    end

    def users_list
      self.class.get("/users.json")
    end

    def time_report_list(from, to = from)
      params = { from: prepare_date(from), to: prepare_date(to) }

      self.class.get("/reports/time/team.json?#{params.to_query}")
    end

    private

    def prepare_date(date)
      date.strftime("%Y%m%d")
    end
  end
end
