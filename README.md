# Harvest Notifier Script

[![Build Status](https://flatstack.semaphoreci.com/badges/harvest-notifier.svg)](https://flatstack.semaphoreci.com/projects/harvest-notifier)
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/fs/harvest-notifier)

This is a ruby library to install on Daily Heroku Scheduler.
It will notification in Slack about users who forgot to mark their working hours in Harvest.
Notification determined from Harvest API V2.

## Work examples

There are 2 type of reports: daily and weekly.
  * Daily Report is generated on weekdays except Monday and shows those users who did not fill in the time for the last day.
  * A weekly report is generated every Monday and shows those users who need to report the required working hours for last week.

## Quick Start

1. Сlone repo
```bash
git clone git@github.com:fs/harvest-notifier.git
cd harvest-notifier
```

2. Setup project
```bash
bin/setup
```

3. Prepare access tokens
  * Create Personal Access Tokens on Harvest: https://id.getharvest.com/developers

  * Create Slack app: https://api.slack.com/apps
  * Create Bot User OAuth Access Token
  * Add following scopes to Bot:
      ```bash
      chat:write
      users:read
      users:read.email
      ```
  * Add app to Slack channel.

4. [Deploy to Heroku](https://heroku.com/deploy?template=https://github.com/fs/harvest-notifier)

5. Configure following ENV variables
    ```bash
    heroku config:set HARVEST_TOKEN=harvest-token
    heroku config:set HARVEST_ACCOUNT_ID=harvest-account-id
    heroku config:set SLACK_TOKEN=slack-bot-token
    heroku config:set SLACK_CHANNEL=slack-channel
    heroku config:set EMAILS_WHITELIST=user1@example.com, user2@example.com, user3@example.com
    heroku config:set MISSING_HOURS_THRESHOLD=1.0
    ```

6. Add job in Heroku Scheduler
  ```bin/rake reports:daily``` for daily report

  ```bin/rake reports:weekly``` for weekly report

### Notice

  ```EMAILS_WHITELIST``` is a variable that lists emails separated by commas, which don't need to be notified in Slack. For example, administrators or managers.

  ```MISSING_HOURS_THRESHOLD```  is a variable that indicates the minimum threshold of hours at which the employee will not be notified in Slack. For example, 2.5 or 4. The default threshold is 1 hour. Leave empty if satisfied with the default value.


## Support

  If you have any questions or suggestions, send an issue, we will try to help you

## Quality tools

* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks

## Develop

`bin/build` checks your specs and runs quality tools

## Credits

It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).

[<img src="http://www.flatstack.com/logo.svg" width="100"/>](http://www.flatstack.com)
