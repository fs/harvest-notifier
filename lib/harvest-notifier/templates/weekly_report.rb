# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class WeeklyReport < Base
      REMINDER_TEXT = "*Guys, don't forget to report the working hours in Harvest every day.*"
      USERS_LIST_TEXT = "Here is a list of people who didn't report the working hours for the last week: *%<period>s*"
      REPORT_NOTICE_TEXT = "_Please, report time and react with :heavy_check_mark: for this message._"
      USER_ITEM = "• <@%<slack_id>s>: *%<missing_hours>s* hours of %<weekly_capacity>s"

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
                json.text format(USERS_LIST_TEXT, period: formatted_period)
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
            # Report Time button
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
              end
            end
          end
        end
      end

      private

      def formatted_period
        "#{assigns[:week_from].strftime('%d %b')} - #{assigns[:week_to].strftime('%d %b %Y')}"
      end

      def users_list
        round_hours(assigns[:users])
          .map { |u| format(USER_ITEM, u) }
          .join("\n")
      end

      def round_hours(users)
        users.each do |u|
          u[:missing_hours] = u[:missing_hours].round(2)
          u[:weekly_capacity] = u[:weekly_capacity].round(2)
        end
      end
    end
  end
end
