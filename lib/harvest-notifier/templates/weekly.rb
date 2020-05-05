# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Weekly < Base
      ALL_LOGGING = "Hooray, everyone reported the working hours for the previous week!"
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
                json.text DEFAULT_TEXT
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
          json.fallback DEFAULT_TEXT
          json.attachments do
            if users.empty?
              json.child! do
                json.text format(ALL_LOGGING)
                json.color "#7CD197"
              end
            else
              json.blocks do
                json.array!(users) do |user|
                  json.type "section"
                  json.color "#7CD197"
                  json.text do
                    json.type "mrkdwn"
                    json.text format(USER_REPORT, "<@#{user['id']}>", user["missing_hours"], user["weekly_capacity"])
                  end
                end
              end
            end
          end
        end
      end

      private

      def channel
        ENV.fetch("SLACK_CHANNEL", "general")
      end
    end
  end
end
