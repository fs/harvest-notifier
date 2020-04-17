# Harvest Notifier Script

[![Build Status](https://flatstack.semaphoreci.com/badges/ruby-base.svg)](https://flatstack.semaphoreci.com/projects/ruby-base)

This is a ruby library to install on Daily Heroku Scheduler.
It will notification in Slack about users who forgot to mark their working hours in Harvest.
Notification determined from Harvest API V2.

## Install

```
#Setup
bin/setup

# Create Heroku app
heroku create harvest-notifier

# Create Heroku Scheduler
heroku addons:create scheduler:standard

# Open Heroku Scheduler and create daily job with `bin/rake reports:daily or reports:weekly`
heroku addons:open scheduler

# Create Rollbar addon to track exceptions
heroku addons:create rollbar:free

# Create Little Snitch to track daily execution
# And configure it to define `SNITCH_DAILY`
heroku addons:create deadmanssnitch

# Configure following ENV variables
heroku config:set ROLLBAR_ENV=production
heroku config:set SNITCH_DAILY=
heroku config:set HARVEST_TOKEN=
heroku config:set HARVEST_ACCOUNT_ID=
heroku config:set SLACK_WEBHOOK_URL=http://rewards.team/api/v1
heroku config:set SLACK_TOKEN=
heroku config:set EMAIL_WHITELIST=
```

## Quality tools

* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks

## Develop

`bin/build` checks your specs and runs quality tools

## Credits

Ruby Base is maintained by [Timur Vafin](http://github.com/timurvafin).
It was written by [Flatstack](http://www.flatstack.com) with the help of our
[contributors](http://github.com/fs/ruby-base/contributors).


[<img src="http://www.flatstack.com/logo.svg" width="100"/>](http://www.flatstack.com)
