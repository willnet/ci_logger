# CiLogger

We run a large number of tests with CI every day. When a test fails, we have to investigate the log, but as it is, the log output is so large that it is difficult to investigate the cause of the failed test.

CiLogger outputs only the log of failed tests. This is useful when investigating the cause of a failed test.

## prerequisite

- rspec
- rails(>= 6.0)

If you want minitest integration, send Pull Request! 

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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
