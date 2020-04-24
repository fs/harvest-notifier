# frozen_string_literal: true

require "active_support/core_ext/date/calculations"
require "jbuilder"
require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Daily < Base
      DEFAULT_TEXT = "Ребята, не не забывайте отмечать часы в Harvest каждый день."
      ALL_LOGGING = "Ура, все залогировали часы за %<current_date>!"
      LIST_OF_USERS = "Вот список людей, кто не отправил часы за %<current_date>:"

      def generate
        {
          text: format(DEFAULT_TEXT),
          attachments: attachments
        }
      end

      private

      def attachments
        Jbuilder.encode do |json|
          json.attachments do
            json.child! do
              json.emails users_data.map(:email)
              json.color "#7CD197"
            end
          end
        end
      end

      def current_date
        Date.yesterday.strftime("%d%B%Y")
      end
    end
  end
end
