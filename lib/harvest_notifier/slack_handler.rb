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

    attr_reader :env

    def call(env)
      @env = env

      return unprocessable_entity("Empty Payload") if payload.blank?
      return unprocessable_entity("Response URL is missing") if response_url.blank?
      return unprocessable_entity("Type is missing") unless ACTION_TYPES.any?(report_params[:type])

      update_report!

      [200, {}, ["OK"]]
    end

    private

    def request
      @request ||= Rack::Request.new(@env)
    end

    def unprocessable_entity(message)
      puts "Params: #{request.params}"
      puts "Payload: #{payload_json}"
      puts "Error: #{message}"

      [422, {}, ["Unprocessable entity: #{message}"]]
    end

    def payload_json
      @payload_json ||= request.params["payload"] || ""
    end

    def payload
      @payload ||=
        begin
          JSON.parse(payload_json)
        rescue JSON::ParserError
          nil
        end
    end

    def response_url
      @response_url ||= payload["response_url"]
    end

    def action_value
      @action_value ||= payload.dig("actions", 0, "value") || ""
    end

    def report_params
      @report_params ||= begin
        type, from, to = action_value.split(":")

        {
          type: type,
          from: from&.to_date,
          to: to&.to_date
        }
      end
    end

    def update_report!
      if report_params[:type] == "daily"
        notifier.create_daily_report(report_params[:from])
      else
        notifier.create_weekly_report(report_params[:from], report_params[:to])
      end
    end

    def notifier
      @notifier ||= HarvestNotifier::Base.new(notification_update_url: response_url)
    end
  end
end
