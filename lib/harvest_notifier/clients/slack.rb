# frozen_string_literal: true

module HarvestNotifier
  module Clients
    class Slack
      API_URL = "https://slack.com/api/"

      attr_reader :token

      def initialize(token)
        @token = token
      end
    end
  end
end
