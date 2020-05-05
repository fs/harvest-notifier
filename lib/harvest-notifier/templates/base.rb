# frozen_string_literal: true

module HarvestNotifier
  module Templates
    class Base
      DEFAULT_TEXT = "Guys, don't forget to report the working hours in Harvest every day."

      attr_reader :users

      def self.generate(users:)
        new(users).generate
      end

      def initialize(users)
        @users = users
      end
    end
  end
end
