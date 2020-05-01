# frozen_string_literal: true

require "harvest-notifier/templates/base"

module HarvestNotifier
  module Templates
    class Weekly < Base
      DEFAULT_TEMPLATE = "Hello World"

      def generate
        format(DEFAULT_TEMPLATE)
      end
    end
  end
end
