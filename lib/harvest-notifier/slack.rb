# frozen_string_literal: true

require "httparty"

module HarvestNotifier
  class Slack
    include HTTParty

    base_uri "https://slack.com/api"

    def initialize(token)
      @token = token
    end

    def post_message(body)
      self.class.post(
        "/chat.postMessage",
        headers: {
          "Content-type" => "application/json",
          "Authorization" => "Bearer #{@token}"
        },
        body: body
      )
    end

    def users_list
      data = []
      receive_users_list.map do |user|
        next if user["deleted"] == true || user["is_bot"] == true

        data << { id: user["id"], email: user["profile"]["email"] }
      end

      data
    end

    private

    def receive_users_list
      value = self.class.get(
        "/users.list",
        headers: {
          "Content-type" => "application/json",
          "Authorization" => "Bearer #{@token}"
        }
      )["members"]

      JSON.parse(value)
    end
  end
end
