# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class WeeklyReport < Base
      REMINDER_TEXT = "Guys, don't forget to report the working hours in Harvest every day."
      USER_REPORT = "%<email>s didn't send %<missing_hours>s* hours out of %<weekly_capacity>s hours"

      def generate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Jbuilder.encode do |json| # rubocop:disable Metrics/BlockLength
          json.channel channel

          json.blocks do
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text REMINDER_TEXT
              end
            end

            json.child! do
              json.type "section"
              json.text do
                json.type "button"
                json.text "Go to Harvest"
                json.url url
                json.style "primary"
              end
            end
          end

          json.attachments do
            json.blocks do
              json.array!(assigns[:users]) do |user|
                json.type "section"
                json.color "#7CD197"
                json.text do
                  json.type "mrkdwn"
                  json.text format(USER_REPORT, user)
                end
              end
            end
          end
        end
      end
    end
  end
end
