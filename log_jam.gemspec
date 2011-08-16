Gem::Specification.new do |s|
  s.name          = 'log_jam'
  s.email         = 'ryan@heroku.com'
  s.version       = '0.0.2'
  s.date          = '2011-08-15'
  s.description   = "LogJam is a proxy to another logger. Say, the Rails logger. This gem intercepts the log message and writes them to a database every now and then."
  s.summary       = "logging utility"
  s.authors       = ["Ryan Smith"]
  s.homepage      = "http://ryandotsmith.heroku.com"

  s.files         = %w[readme.md log_jam.rb]
  s.test_files    = %w[log_jam_test.rb]
  s.require_paths = %w[.]
end
