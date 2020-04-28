# frozen_string_literal: true

require "active_support/core_ext/date/calculations"
require "jbuilder"
require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Daily < Base
      DEFAULT_TEXT = "Ребята, не забывайте отмечать часы в Harvest каждый день."
      ALL_LOGGING = "Ура, все отметили часы за %s!"
      LIST_OF_USERS = "Вот список людей, кто не отправил часы за %s: %s"

      def generate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Jbuilder.encode do |json|
          json.channel channel
          json.text DEFAULT_TEXT
          json.fallback DEFAULT_TEXT
          json.attachments do
            json.child! do
              json.text text
              json.color "#7CD197"
              json.actions do
                json.child! do
                  json.type "button"
                  json.text "Go to Harvest"
                  json.url "https://flatstack.harvestapp.com/time/week/"
                  json.style "primary"
                end
              end
            end
          end
        end
      end

      private

      def text
        if users_data.empty?
          format(ALL_LOGGING, current_date)
        else
          format(LIST_OF_USERS, current_date, mention_users)
        end
      end

      def current_date
        Date.yesterday.strftime("%d %B %Y")
      end

      def mention_users
        ids = users_data.map do |user|
          user[:id] ? "<@#{user[:id]}>" : user[:email]
        end

        ids.join(", ")
      end

      def channel
        ENV.fetch("SLACK_CHANNEL", "general")
      end
    end
  end
end
