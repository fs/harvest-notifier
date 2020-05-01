# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module HarvestNotifier
  class Report
    attr_reader :harvest_client

    delegate :users_list, :time_report_list, to: :harvest_client, prefix: :harvest

    def initialize(harvest_client)
      @harvest_client = harvest_client
    end

    def daily
      reports = prepare_daily_reports(harvest_time_report_list(Date.yesterday))

      users.reject! do |user|
        whitelisted_user?(user) || time_reported?(reports, user)
      end

      users.map do |u|
        {
          "email" => u["email"]
        }
      end
    end

    def weekly
      raw_reports = harvest_time_report_list(Date.today.last_week, Date.today.last_week + 4)

      reports = prepare_weekly_reports(raw_reports)

      result_users = calculate_hours(users, reports)

      result_users.reject! do |user|
        whitelisted_user?(user) || user["missing_hours"] <= ENV["WEEKLY_REPORT_HOURS"].to_f
      end
    end

    private

    def emails_whitelist
      @emails_whitelist ||= ENV["EMAILS_WHITELIST"].split(",").map(&:strip)
    end

    def whitelisted_user?(user)
      emails_whitelist.include?(user["email"])
    end

    def calculate_hours(users, reports)
      users.map do |user|
        report = reports.find { |r| r["user_id"] == user["id"] }

        weekly_capacity = user["weekly_capacity"] / 3600
        missing_hours = report.nil? ? weekly_capacity : missing_hours(weekly_capacity, report["total_hours"])

        {
          "email" => user["email"],
          "weekly_capacity" => weekly_capacity,
          "missing_hours" => missing_hours
        }
      end
    end

    def missing_hours(weekly_capacity, reported_hours)
      weekly_capacity - reported_hours
    end

    def prepare_weekly_reports(reports)
      reports["results"].map { |r| r.slice("user_id", "total_hours") }
    end

    def prepare_daily_reports(reports)
      reports["results"].map { |r| r["user_id"] }
    end

    def time_reported?(reports, user)
      reports.include?(user["id"])
    end

    def users
      @users ||= harvest_users_list["users"].map { |u| u.slice("id", "email", "weekly_capacity") }
    end
  end
end
