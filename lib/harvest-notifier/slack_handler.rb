# frozen_string_literal: true

require "rack"
require "json"
require "active_support/json"
require "active_support/core_ext/object/json"

module HarvestNotifier
  class SlackHandler
    def call(env)
      req = Rack::Request.new(env)

      unless req.params.include?("payload")
        return unprocessable_entity("Payload param is missing")
      end

      unless payload = parse_payload(req.params["payload"])
        return unprocessable_entity("Empty Payload")
      end

      puts payload["response_url"]

      [200, { "Content-Type" => "text/plain" }, ["OK"]]
    end

    private

    def unprocessable_entity(message)
      [422, {}, ["Unprocessable entity: #{message}"]]
    end

    def parse_payload(json)
      JSON.parse(json)
    rescue JSON::ParserError
      nil
    end
  end
end
