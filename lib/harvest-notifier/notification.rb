# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module HarvestNotifier
  class Notification
    attr_reader :slack_client, :users, :template

    delegate :post_message, :users_list, to: :slack_client, prefix: :slack

    def initialize(slack_client, users, template)
      @slack_client = slack_client
      @users = users
      @template = template
    end

    def deliver
      slack_post_message(generate_from_template)
    end

    private

    def prepared_users
      return if users.empty?

      users.map do |user|
        slack_user = slack_users.find { |u| u["profile"]["email"] == user["email"] }

        user["id"] = slack_user["id"]
      end

      users
    end

    def slack_users
      @slack_users ||= slack_users_list["members"].reject do |u|
        u["deleted"] || u["is_bot"]
      end
    end

    def generate_from_template
      template.generate(users: prepared_users)
    end
  end
end
