# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"

require "harvest_notifier/templates/daily_report"
require "harvest_notifier/templates/weekly_report"
require "harvest_notifier/templates/congratulation"

module HarvestNotifier
  class Notification
    attr_reader :slack_client, :update_url

    delegate :post_message, :update_message, to: :slack_client, prefix: :slack

    def initialize(slack_client, update_url: nil)
      @slack_client = slack_client
      @update_url = update_url
    end

    def deliver(template_name, assigns = {})
      message = template_klass(template_name).generate(assigns)

      if update_url
        slack_update_message(message, update_url)
      else
        slack_post_message(message)
      end
    end

    private

    def template_klass(template_name)
      "HarvestNotifier::Templates::#{template_name.to_s.classify}".constantize
    end
  end
end
