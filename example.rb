DB = Sequel.sqlite(:logger => Logger.new('sql.log'))

DB.create_table :events do
  primary_key :id
end

DB.create_table :event_logs do
  primary_key :id
  foreign_key :event_id, :events
  String :message
end

DB.create_table :accounts do
  primary_key :id
end

DB.create_table :account_logs do
  primary_key :id
  foreign_key :account_id, :accounts
  String :message
end


class Event < Sequel::Model
  one_to_many :event_logs
end

class EventLog < Sequel::Model
  many_to_one :event
end

class Account < Sequel::Model
  one_to_many :account_logs
end

class AccountLog < Sequel::Model
  many_to_one :account
end


Event.create
Account.create

class Provider < Sinatra::Application

  get "/events" do
    event = Event.first
    account = Account.first

    splunk_logger = Logger.new("splunk.log")
    LogJam.setup_logger(splunk_logger, :info)

    LogJam.priorities(:account, :event)
    LogJam.puts("event=#{event.id} account=#{account.id} time=#{Time.now.to_i}")
    LogJam.write_to_disk
    event.event_logs.map(&:message).join("<br />")
  end

end
