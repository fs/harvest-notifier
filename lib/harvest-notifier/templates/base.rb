# frozen_string_literal: true

require "jbuilder"

module HarvestNotifier
  module Templates
    class Base
      attr_reader :assigns, :channel

      def self.generate(assigns = {})
        new(assigns).generate
      end

      def initialize(assigns)
        @channel = ENV.fetch("SLACK_CHANNEL", "general")
        @assigns = assigns
      end

      def generate; end
    end
  end
end
