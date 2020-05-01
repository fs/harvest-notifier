# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module HarvestNotifier
  class SlackSender
    attr_reader :slack_client, :users_data, :template

    delegate :post_message, :users_list, to: :slack_client, prefix: :slack

    def initialize(slack_client, users_data, template)
      @slack_client = slack_client
      @users_data = users_data
      @template = template
    end

    def notify
      byebug
      slack_post_message(generate_from_template)
    end

    private

    def prepared_users_data
      users_data.map do |user|
        slack_user = slack_users.find { |u| u["email"] == user["email"] }

        user["id"] = slack_user["id"]
      end

      users_data
    end

    def slack_users
      @slack_users ||= slack_users_list["members"].map do |u|
        next if u["deleted"] || u["is_bot"]

        { "id" => u["id"],
          "email" => u["profile"]["email"]
        }
      end.compact
    end

    def generate_from_template
      template.generate(users_data: prepared_users_data)
    end
  end
end
