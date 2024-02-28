# CiLogger

We perform a significant number of tests using CI on a daily basis. Whenever a test fails, we need to examine the log. However, the current log output is excessively large, making it challenging to identify the root cause of the failed test.

CiLogger specifically generates logs for failed tests, which proves invaluable during the investigation of test failures.

## prerequisite

- rspec or minitest
- rails(>= 6.1)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ci_logger', group: :test
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ci_logger
```

Add this line to your config/environments/test.rb

```ruby
config.ci_logger.enabled = ENV['CI']
```

You can replace `ENV['CI']` with what you like.

## Replace loggers besides rails logger

CiLogger replaces Rails.logger by default, but other loggers can be replaced.

```ruby
your_logger = CiLogger.new(your_logger)
your_logger.debug('debug!') # This is only output when the test fails
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
