# frozen_string_literal: true

require "jbuilder"

module HarvestNotifier
  module Templates
    class Base
      attr_reader :assigns, :channel, :url

      def self.generate(assigns = {})
        new(assigns).generate
      end

      def initialize(assigns)
        @channel = ENV.fetch("SLACK_CHANNEL", "general")
        @url = ENV.fetch("HARVEST_URL", "https://harvestapp.com/")

        @assigns = assigns
      end

      def generate; end
    end
  end
end
