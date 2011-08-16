# LogJam

A proxy that persists log messages to a database.

## Requirements

LogJam will send `Rails.logger.info` log messages.
LogJam also will call ActiveRecord like classes. `AccountLog.create({})`

## Usage

```ruby
  # the order of our priorities determines which table the log will be stored in.
  LogJam.priorities(:invoice, :account)

  # LogJam will also pass this message to Rails.logger.info
  LogJam.puts("account=123 invoice=456  invoice created")

  # This message drains the logs and figures out how to write to the database.
  # Since we defined our first priority as :invoice, LogJam will ask the kernel
  # for the InvoiceLog class. It will then send the create message to the class
  # with parameters that look like this: {:invoice_id => 456, :message => "account=123 invoice=456  invoice created"}
  LogJam.write_to_disk
```
