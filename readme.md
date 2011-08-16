# LogJam

A proxy that persists log messages to a database.

## Usage

```ruby
  LogJam.puts("account=123 invoice=456  invoice created")
  LogJam.puts("account=123 page=true core services off-line")
```
