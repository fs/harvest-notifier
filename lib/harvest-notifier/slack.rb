# frozen_string_literal: true

require "httparty"

module HarvestNotifier
  class Slack
    include HTTParty

    base_uri "https://slack.com/api"
    headers "Content-type" => "application/json"
    logger ::Logger.new STDOUT

    def initialize(token)
      self.class.headers "Authorization" => "Bearer #{token}"
    end

    def post_message(body)
      self.class.post("/chat.postMessage", body: body)
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
