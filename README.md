# CiLogger

In our CI process, we often look at logs to figure out issues with flaky tests—tests that fail sometimes but not always, especially when we can't make them fail in the same way on our own computers. The problem is, it's hard to tell which logs are about the failed tests because logs from tests that passed and failed are all mixed together.

CiLogger makes this easier by only keeping logs from tests that didn't pass, including the tricky flaky ones. This means when a flaky test won't fail the same way for us locally, we can quickly find and look at the right logs to help us understand and fix the problem.

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
