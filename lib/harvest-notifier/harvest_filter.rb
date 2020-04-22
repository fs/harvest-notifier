# frozen_string_literal: true

module HarvestNotifier
  class HarvestFilter
    def initialize(users, time_report)
      @harvest_users = users
      @time_report = time_report
    end

    def daily_report
      users = reject_users

      get_emails(users)
    end

    private

    def get_emails(users)
      users.map { |u| u[:email] }
    end

    def reject_users
      @harvest_users.reject do |user|
        report_user_ids.include?(user[:id]) || emails_whitelist.include?(user[:email])
      end
    end

    def report_user_ids
      @report_user_ids ||= @time_report.map { |r| r[:user_id] }
    end

    def emails_whitelist
      ENV["EMAILS_WHITELIST"].split(",")
    end
  end
end
