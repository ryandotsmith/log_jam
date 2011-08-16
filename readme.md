# log_jam

A proxy that persists log messages to a database.

## Requirements

log_jam will call an ActiveRecord like class. `AccountLog.create({})`

## Install

```bash
$ gem install log_jam
```

## Usage

```ruby
  # log_jam will pass along log messages in real time. log_jam will not wait for
  # you to call drain before it sends messages to the default logger.
  LogJam.setup_logger(Rails.logger, :info)

  # the order of our priorities determines which table the log will be stored in.
  LogJam.priorities(:invoice, :account)

  # log_jam will also pass this message to Rails.logger.info
  LogJam.puts("account=123 invoice=456  invoice created")

  # This message drains the logs and figures out how to write to the database.
  # Since we defined our first priority as :invoice, LogJam will ask the kernel
  # for the InvoiceLog class. It will then send the create message to the class
  # with parameters that look like this: {:invoice_id => 456, :message => "account=123 invoice=456  invoice created"}
  LogJam.write_to_disk
```

## Hacking on log_jam

I think this lib is feature complete; however, if you find a bug please add a test. To run the tests:

```bash
$ ruby log_jam_test.rb
```
