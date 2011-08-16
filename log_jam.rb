module LogJam
  extend self

  @@logs = []

  def setup_logger(logger, level)
    @@default_logger = logger
    @@default_level = level
  end

  def priorities(*list)
    @@priorities = list
  end

  def puts(msg)
    @@logs << msg
    if defined? @@default_logger
      @@default_logger.send(@@default_level, msg)
    end
  end

  def write_to_disk
    logs = drain
    @@priorities.select {|p| logs.keys.include?(p) }.map do |filter|
      logs[filter].each do |log|
        klass = Kernel.const_get(camelize(filter.to_s + "_log"))
        klass.create("#{filter}_id" => grep_id(filter, log), :message => log)
      end
    end.all?
  end

  def drain
    result = {}
    until @@logs.empty? do
      log = @@logs.pop
      @@priorities.each do |filter|
        if filtered_id = grep_id(filter.to_s, log)
          result[filter] ||= []
          result[filter] << log
          break
        end
      end
    end
    result
  end

  def grep_id(term, string)
    if match = string.match(/#{term}=?(\d*)/)
      id = match.captures[0]
      if id.respond_to?(:to_i)
        id.to_i
      else
        raise "LogJam Error: expected #{term}=#{id} to contain an integer"
      end
    end
  end

  def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end

end
