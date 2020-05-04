# frozen_string_literal: true

module HarvestNotifier
  module Templates
    class Base
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
