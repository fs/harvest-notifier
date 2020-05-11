# Harvest Notifier Script

[![Build Status](https://flatstack.semaphoreci.com/badges/harvest-notifier.svg)](https://flatstack.semaphoreci.com/projects/harvest-notifier)

This is a ruby library to install on Daily Heroku Scheduler.
It will notification in Slack about users who forgot to mark their working hours in Harvest.
Notification determined from Harvest API V2.

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

  3.1 Create Personal Access Tokens on Harvest
  [![Harvest](https://www.getharvest.com/assets/press/harvest-logo-capsule-9b74927af1c93319c7d6c47ee89d4c2d442f569492c82899b203dd3bdeaa81a4.png){:height="250px" width="250px"}](https://id.getharvest.com/developers)

  3.2 Create Slack app
  [![Slack](https://cdn.brandfolder.io/5H442O3W/at/pl546j-7le8zk-6gwiyo/Slack_Mark.svg){:height="250px" width="250px"}](https://api.slack.com/apps)

  3.3 Create Bot User OAuth Access Token
  3.4 Add following scopes:
  ```bash
  chat:write
  incoming-webhook
  users:read
  users:read.email
  ```

4. [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/fs/harvest-notifier)

5. Configure following ENV variables
```bash
heroku config:set ROLLBAR_ACCESS_TOKEN=
heroku config:set SNITCH_DAILY=
heroku config:set HARVEST_TOKEN=
heroku config:set HARVEST_ACCOUNT_ID=
heroku config:set SLACK_TOKEN=
heroku config:set SLACK_CHANNEL=
heroku config:set EMAILS_WHITELIST=
heroku config:set MISSING_HOURS_THRESHOLD=
```

## Quality tools

* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks

## Develop

`bin/build` checks your specs and runs quality tools

## Credits

It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).

[<img src="http://www.flatstack.com/logo.svg" width="100"/>](http://www.flatstack.com)
