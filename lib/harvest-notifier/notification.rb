# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"

require "harvest-notifier/templates/daily_report"
require "harvest-notifier/templates/weekly_report"
require "harvest-notifier/templates/congratulation"

module HarvestNotifier
  class Notification
    attr_reader :slack_client, :assigns

    delegate :post_message, to: :slack_client, prefix: :slack

    def initialize(slack_client, assigns)
      @slack_client = slack_client
      @assigns = assigns
    end

    def deliver(template_name)
      slack_post_message(template_klass(template_name).generate(assigns))
    end

    private

    def template_klass(template_name)
      "HarvestNotifier::Templates::#{template_name.to_s.classify}".constantize
    end
  end
end
