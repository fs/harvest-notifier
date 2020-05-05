# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class DailyReport < Base
      REMINDER_TEXT = "Guys, don't forget to report the working hours in Harvest every day."
      LIST_OF_USERS = "Here is a list of people who didn't report the working hours for the previous day: %s"

      def generate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Jbuilder.encode do |json|
          json.channel channel
          json.text REMINDER_TEXT
          json.fallback REMINDER_TEXT
          json.attachments do
            json.child! do
              json.text text
              json.color "#7CD197"
              json.actions do
                json.child! do
                  json.type "button"
                  json.text "Go to Harvest"
                  json.url "https://flatstack.harvestapp.com/time/"
                  json.style "primary"
                end
              end
            end
          end
        end
      end

      private

      def text
        format(LIST_OF_USERS, assigns[:users].map { |u| u["email"] }.join(", "))
      end
    end
  end
end
