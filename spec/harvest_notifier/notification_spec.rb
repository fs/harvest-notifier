# frozen_string_literal: true

describe HarvestNotifier::Notification do
  subject(:notification) { described_class.new(slack, users, template) }

  let(:slack) { instance_double(HarvestNotifier::Slack) }

  let(:users) do
    [
      {
        "email" => "bill.doe@example.com",
        "missing_hours" => 5.0,
        "total_hours" => 35.0,
        "weekly_capacity" => 40
      }
    ]
  end

  let(:slack_users) do
    {
      "members" => [
        {
          "id" => "U01TEST",
          "profile" =>
          {
            "email" => "john.smith@example.com"
          }
        },
        {
          "id" => "U02TEST",
          "profile" =>
          {
            "email" => "bill.doe@example.com"
          }
        }
      ]
    }
  end

  let(:response) { { status: 200 } }

  before do
    allow(template).to receive(:generate).with(users: users) { body }
    allow(slack).to receive(:users_list) { slack_users }
    allow(slack).to receive(:post_message).with(body) { response }
  end

  describe "#deliver" do
    context "when daily template is set" do
      let(:template) { class_double(HarvestNotifier::Templates::Daily) }

      let(:body) do
        "{
          \"channel\":\"test\",
          \"text\":\"Ребята, не забывайте отмечать часы в Harvest каждый день.\",
          \"fallback\":\"Ребята, не забывайте отмечать часы в Harvest каждый день.\",
          \"attachments\":
          [
            {
              \"text\":\"Вот список людей, кто не отправил часы за предыдущий день: <@U02TEST>\",
              \"color\":\"#7CD197\",
              \"actions\":
              [
                {
                  \"type\":
                  \"button\",
                  \"text\":\"Go to Harvest\",
                  \"url\":\"https://flatstack.harvestapp.com/time/\",
                  \"style\":\"primary\"
                }
              ]
            }
          ]
        }"
      end

      it "sends daily report data to Slack" do
        expect(template).to receive(:generate).with(users: users)
        expect(slack).to receive(:post_message).with(body)

        notification.deliver
      end
    end

    context "when weekly template is set" do
      let(:template) { class_double(HarvestNotifier::Templates::Weekly) }

      let(:body) do
        "{
          \"channel\":\"test\",
          \"blocks\":
          [
            {
              \"type\":\"section\",
              \"text\":
              {
                \"type\":\"mrkdwn\",
                \"text\":\"Guys, don't forget to report the working hours in Harvest every day.\"
              }
            },
            {
              \"type\":\"section\",
              \"text\":
              {
                \"type\":\"button\",
                \"text\":\"Go to Harvest\",
                \"url\":\"https://flatstack.harvestapp.com/time/\",
                \"style\":\"primary\"
              }
            }
          ],
          \"fallback\":\"Guys, don't forget to report the working hours in Harvest every day.\",
          \"attachments\":
          {
            \"blocks\":
            [
              {
                \"type\":\"section\",
                \"color\":\"#7CD197\",
                \"text\":
                {
                  \"type\":\"mrkdwn\",
                  \"text\":\"<@U02TEST> didn't send 5.0* hours out of 40.0 hours\"
                }
              }
            ]
          }
        }"
      end

      it "sends weekly report data to Slack" do
        expect(template).to receive(:generate).with(users: users)
        expect(slack).to receive(:post_message).with(body)

        notification.deliver
      end
    end
  end
end
