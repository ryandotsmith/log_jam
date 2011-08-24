# log_jam

## Requirements

log_jam will call an ActiveRecord like class. `AccountLog.create(:account_id => int, :message => text)`

This class must represent a table that has 2 columns: *foreign_key account_id, text message*.

## Install

```bash
$ gem install log_jam
```

## Usage

### Why

In my production environment, I send all of my logs to either loggly or
papertrail -- still waiting on splunk as a service.... However, there are
certain situations in which I want to display logs via an HTML interface. For
instance, the support team at Heroku finds it useful to see the logs of credit
card transactions in the same web UI that details customer account
information. For that reason, I keep a subset of my logs in a postgresql
database. Now my logs are one simple query away from an HTML page.

`SELECT * FROM account_logs WHERE account_id = x`

I am also of the opinion that logs are data. There is value in being able to
reason about the behaviour of your system by means of empirical evidence. What
better way to query your data set than SQL.

### API

```ruby
  require 'log_jam'
  
  # log_jam will pass along log messages in real time. log_jam will not wait for
  # you to call drain before it sends messages to the default logger.
  LogJam.setup_logger(Rails.logger, :info)

  # the order of our priorities determines which table the log will be stored in.
  LogJam.priorities(:invoice, :account)

  # log_jam will also pass this message to Rails.logger.info
  LogJam.puts("account=123 invoice=456  invoice created")

  # Optional
  # If you don't care about writing to disk, you can call drain to get a hash of
  # your prioritized log messages. BUT it will definitely drain, so do this only if
  # you are not wanting to call write_to_disk.
  LogJam.drain #=> {:invoice => ["account=123 invoice=456  invoice created"]}

  # This message drains the logs and figures out how to write to the database.
  # Since we defined our first priority as :invoice, log_jam will ask the Kernel class
  # for the InvoiceLog class. It will then send the create message to the class
  # with parameters that look like this: {:invoice_id => 456, :message => "account=123 invoice=456  invoice created"}
  LogJam.write_to_disk
```

## Hacking on log_jam

I think this lib is feature complete; however, if you find a bug please add a test. To run the tests:

```bash
$ ruby log_jam_test.rb
```
