# frozen_string_literal: true

module HarvestNotifier
  class SlackSender
    attr_reader :users_data, :template

    def initialize(users_data, template)
      @users_data = users_data
      @template = template
    end

    def notify
      client.chat_postMessage(channel: ENV["SLACK_CHANNEL"],
                              text: text,
                              attachments: attachments)
    end

    private

    def text
      generate_from_template[:text]
    end

    def attachments
      generate_from_template[:attachments]
    end

    def generate_from_template
      template.generate(users_data)
    end

    def client
      Slack::Web::Client.new
    end
  end
end
