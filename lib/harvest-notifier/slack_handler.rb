# frozen_string_literal: true

require "rack"
require "json"
require "active_support/json"
require "active_support/core_ext/object/json"

module HarvestNotifier
  class SlackHandler
    def call(env)
      req = Rack::Request.new(env)

      return unprocessable_entity("Payload is missing") if req.params["payload"].nil?

      payload = parse_payload(req.params["payload"])
      return unprocessable_entity("Empty Payload") if payload.nil?

      response_url = payload["response_url"]
      return unprocessable_entity("Response URL is missing") if response_url.nil?

      action_type, date_from, date_to = action_type(payload)
      return unprocessable_entity("Action Type is missing") if action_type.nil?

      case action_type
      when :daily
        daily_report
      when :weekly
        weekly_report
      else
        return unprocessable_entity("Invalid Action Type")
      end
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

    def daily_report(date_from)
    end

    def weekly_report(date_from, date_to)
    end
  end
end
