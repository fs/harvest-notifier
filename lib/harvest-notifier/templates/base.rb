# frozen_string_literal: true

module HarvestNotifier
  module Templates
    class Base
      attr_reader :users_data

      def self.generate(users_data:)
        new(users_data).generate
      end

      def initialize(users_data)
        @users_data = users_data
      end
    end
  end
end
