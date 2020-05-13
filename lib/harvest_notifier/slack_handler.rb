# frozen_string_literal: true

require "rack"
require "json"
require "active_support/json"
require "active_support/core_ext/object/json"
require "active_support/core_ext/string/conversions"

require "harvest_notifier/base"

module HarvestNotifier
  class SlackHandler
    ACTION_TYPES = %w[daily weekly].freeze

    def call(env)
      request = Rack::Request.new(env)
      payload = parse_payload(payload_json(request))
      response_url = payload["response_url"]
      action_params = parse_action_params(action_value(payload))

      return unprocessable_entity("Empty Payload", request) if payload.blank?
      return unprocessable_entity("Response URL is missing", request) if response_url.blank?
      return unprocessable_entity("Type is missing", request) unless ACTION_TYPES.any?(action_params[:type])

      update_report!(action_params, response_url)

      [200, {}, ["OK"]]
    end

    private

    def unprocessable_entity(message, request)
      puts "Error: #{message}"
      puts "Request: #{request.inspect}"

      [422, {}, ["Unprocessable entity: #{message}"]]
    end

    def payload_json(request)
      request.params["payload"] || ""
    end

    def action_value(payload)
      payload.dig("actions", 0, "value") || ""
    end

    def parse_payload(json)
      JSON.parse(json)
    rescue JSON::ParserError
      {}
    end

    def parse_action_params(action_value)
      type, from, to = action_value.split(":")

      {
        type: type,
        from: from&.to_date,
        to: to&.to_date
      }
    end

    def update_report!(action_params, response_url)
      notifier = HarvestNotifier::Base.new(notification_update_url: response_url)

      if action_params[:type] == "daily"
        notifier.create_daily_report(action_params[:from])
      else
        notifier.create_weekly_report(action_params[:from], action_params[:to])
      end
    end
  end
end
