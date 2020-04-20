# frozen_string_literal: true

module HarvestNotifier
  module Clients
    class Harvest
      API_URL = "https://api.harvestapp.com/api/v2"

      attr_reader :account_id, :token

      def initialize(account_id, token)
        @account_id = account_id
        @token = token
      end

      def users_list
        active_users.map do |user|
          data = {
            id: user["id"],
            user_name: user_fullname(user),
            user_email: user["email"],
            weekly_capacity: user["weekly_capacity"]
          }

          User.new(data)
        end
      end

      def time_report_list(from, to)
        time_report(from, to).map do |report|
          {
            user_id: report["user_id"],
            user_name: report["user_name"],
            result_capacity: activity_time(report["total_hours"])
          }
        end
      end

      private

      def auth_headers
        { "Authorization" => "Bearer #{token}", "Harvest-Account-Id" => account_id }
      end

      def to_param(options)
        options.presence ? "?#{options.map { |k, v| "#{k}=#{v}" }.join('&')}" : ""
      end

      def get(resource, options = {})
        resource_url = "#{API_URL}/#{resource}.json#{to_param(options)}"
        response = HTTParty.get(resource_url, headers: auth_headers)
        response.success? ? JSON.parse(response.body) : nil
      end

      def active_users
        result = get("users", { is_active: true })

        @active_users ||= result ? result["users"] : []
      end

      def time_report(from, to)
        result = get("reports/time/team", { from: prepare_date(from), to: prepare_date(to) })

        @time_report ||= result ? result["results"] : []
      end

      def user_fullname(user)
        [user["first_name"], user["last_name"]].compact.join(" ")
      end

      def activity_time(hours)
        hours.to_i * 3600
      end

      def prepare_date(date)
        date.strftime("%Y%m%d")
      end
    end
  end
end
