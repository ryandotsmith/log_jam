$:.unshift(".")
require 'log_jam.rb'
require 'minitest/autorun'

class Rails
  def self.logger
    def self.info(str)
      puts str
    end
    self
  end
end

class Log
  def self.create(*args)
    true
  end
end
class AccountLog < Log; end
class InvoiceLog < Log; end

class LogJamTest < MiniTest::Unit::TestCase

  def test_write_to_disk
    log_msg = "invoice=123 account=123"
    LogJam.priorities(:invoice, :account)
    LogJam.puts(log_msg)
    assert LogJam.write_to_disk
  end

  def test_write_to_disk_fails_when_storage_not_defined
    log_msg = "line_items=123 invoice=123 account=123"
    LogJam.priorities(:line_item, :invoice, :account)
    LogJam.puts(log_msg)
    assert_raises(NameError) { LogJam.write_to_disk }
  end

  def test_drain_with_priority
    log_msg = "invoice=123 account=123"
    LogJam.priorities(:invoice, :account)
    LogJam.puts(log_msg)
    assert_equal({:invoice => [log_msg]}, LogJam.drain)
  end

  def test_drain_with_priority_when_first_priority_not_present
    log_msg = "line_item=123 account=123"
    LogJam.priorities(:invoice, :account)
    LogJam.puts(log_msg)
    assert_equal({:account => [log_msg]}, LogJam.drain)
  end


end
