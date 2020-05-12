# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class DailyReport < Base
      REMINDER_TEXT = "*Guys, don't forget to report the working hours in Harvest every day.*"
      USERS_LIST_TEXT = "Here is a list of people who didn't report the working hours for *%<current_date>s*:"
      REPORT_NOTICE_TEXT = "_Please, report time and react with :heavy_check_mark: for this message._"
      USER_ITEM = "• <%<slack_id>s>"

      def generate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Jbuilder.encode do |json| # rubocop:disable Metrics/BlockLength
          json.channel channel
          json.blocks do # rubocop:disable Metrics/BlockLength

            # Reminder text
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text REMINDER_TEXT
              end
            end

            # Pretext list of users
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text format(USERS_LIST_TEXT, current_date: formatted_date)
              end
            end

            # List of users
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text users_list
              end
            end

            # Report notice
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text REPORT_NOTICE_TEXT
              end
            end

            # Buttons
            json.child! do
              json.type "actions"
              json.elements do
                json.child! do
                  json.type "button"
                  json.url url
                  json.style "primary"
                  json.text do
                    json.type "plain_text"
                    json.text "Report Time"
                  end
                end

                json.child! do
                  json.type "button"
                  json.text do
                    json.type "plain_text"
                    json.text ":repeat: Refresh"
                  end
                  json.value refresh_value
                end
              end
            end
          end
        end
      end

      private

      def formatted_date
        assigns[:date].strftime("%B%eth")
      end

      def refresh_value
        "daily:#{assigns[:date]}"
      end

      def users_list
        assigns[:users]
          .map { |u| format(USER_ITEM, u) }
          .join("\n")
      end
    end
  end
end
