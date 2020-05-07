# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Congratulation < Base
      def generate # rubocop:disable Metrics/MethodLength
        Jbuilder.encode do |json|
          json.channel channel
          json.attachments do
            json.child! do
              json.text "Hooray, everyone reported the working hours!"
              json.color "#7CD197"
              json.actions do
                json.child! do
                  json.type "button"
                  json.text "Go to Harvest"
                  json.url ENV.fetch("HARVEST_URL", "https://harvestapp.com/")
                  json.style "primary"
                end
              end
            end
          end
        end
      end
    end
  end
end
