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
      reports = prepare_reports(harvest_time_report_list(Date.yesterday))

      users.reject do |user|
        whitelisted_user?(user) || time_reported?(reports, user)
      end
    end

    def weekly; end

    private

    def emails_whitelist
      @emails_whitelist ||= ENV["EMAILS_WHITELIST"].split(",").map(&:strip)
    end

    def whitelisted_user?(user)
      emails_whitelist.include?(user["email"])
    end

    def prepare_reports(reports)
      reports["results"].map { |r| r["user_id"] }
    end

    def time_reported?(reports, user)
      reports.include?(user["id"])
    end

    def users
      @users ||= harvest_users_list["users"].map { |u| u.slice("id", "email") }
    end
  end
end
