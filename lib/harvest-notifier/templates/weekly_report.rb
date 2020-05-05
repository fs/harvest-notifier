# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class WeeklyReport < Base
      REMINDER_TEXT = "Guys, don't forget to report the working hours in Harvest every day."
      LIST_OF_USERS = "Here is a list of people who didn't report the working hours for the previous week: %s"
      USER_REPORT = "%s didn't send %s* hours out of %s hours"

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
                json.url "https://flatstack.harvestapp.com/time/"
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
                  json.text "#{user['email']} didn't send #{user['missing_hours']}* hours \
                    out of #{user['weekly_capacity']} hours"
                end
              end
            end
          end
        end
      end
    end
  end
end
