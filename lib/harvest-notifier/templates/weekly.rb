# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Weekly < Base
      ALL_LOGGING = "Hooray, everyone reported the working hours for the previous week!"
      LIST_OF_USERS = "Here is a list of people who didn't report the working hours for the previous week: %s"

      def generate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Jbuilder.encode do |json|
          json.channel channel
          json.text DEFAULT_TEXT
          json.fallback DEFAULT_TEXT
          json.attachments do
            json.child! do
              json.text attachment_text
              json.color "#7CD197"
              json.actions do
                json.child! do
                  json.type "button"
                  json.text "Go to Harvest"
                  json.url "https://flatstack.harvestapp.com/time"
                  json.style "primary"
                end
              end
            end
          end
        end
      end

      private

      def attachment_text
        if users.empty?
          format(ALL_LOGGING)
        else
          format(LIST_OF_USERS, mention_users)
        end
      end

      def mention_users
        mention_users = users.map do |user|
          user["id"] ? "<@#{user['id']}>" : user["email"]
        end

        mention_users.join(", ")
      end

      def channel
        ENV.fetch("SLACK_CHANNEL", "general")
      end
    end
  end
end
