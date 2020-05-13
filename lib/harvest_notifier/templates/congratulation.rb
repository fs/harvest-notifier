# frozen_string_literal: true

require "harvest_notifier/templates/base"

module HarvestNotifier
  module Templates
    class Congratulation < Base
      def generate # rubocop:disable Metrics/MethodLength
        Jbuilder.encode do |json|
          json.channel channel
          json.blocks do
            json.child! do
              json.type "section"
              json.text do
                json.type "mrkdwn"
                json.text "*Hooray, everyone reported the working hours!* :tada:"
              end
            end
          end
        end
      end
    end
  end
end
