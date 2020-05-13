# frozen_string_literal: true

describe HarvestNotifier::Notification do
  subject(:notification) { described_class.new(slack_double, update_url: update_url) }

  let(:slack_double) { instance_double(HarvestNotifier::Slack) }

  let(:update_url) { nil }
  let(:template) { HarvestNotifier::Templates::Base }
  let(:template_name) { :base }
  let(:assigns) { { users: [{ "email": "john.doe@example.com" }] } }
  let(:template_body) { "Hello!" }

  before do
    allow(template).to receive(:generate).with(assigns) { template_body }
    allow(slack_double).to receive(:post_message).with(template_body)
  end

  describe "#deliver(template_name)" do
    it "generates notification text by template_name" do
      expect(template).to receive(:generate).with(assigns)
      notification.deliver(template_name, assigns)
    end

    it "sends message to Slack" do
      expect(slack_double).to receive(:post_message).with(template_body)
      notification.deliver(template_name, assigns)
    end

    context "with update_url passed" do
      let(:update_url) { "http://hook.slack.com" }

      it "updates message in Slack" do
        expect(slack_double).to receive(:update_message).with(template_body, update_url)
        notification.deliver(template_name, assigns)
      end
    end
  end
end
