# frozen_string_literal: true

module HarvestNotifier
  class SlackSender
    attr_reader :users_data, :template

    def initialize(users_data, template)
      @users_data = users_data
      @template = template
    end

    def notify
      client.post_message(generate_from_template)
    end

    private

    def slack_users
      @slack_users ||= client.users_list
    end

    def prepared_users_data
      users_data.map do |user|
        slack_users.map do |slack_user|
          next if user[:email] != slack_user[:email]

          user[:id] = slack_user[:id]
        end
      end

      users_data
    end

    def generate_from_template
      template.generate(users_data: prepared_users_data)
    end

    def client
      HarvestNotifier::Slack.new
    end
  end
end
