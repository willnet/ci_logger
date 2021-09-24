# CiLogger

Faster Logger for CI

## prerequisite

- rspec
- rails(>= 5.2)

If you want minitest integration, send Pull Request! 

## Usage

As time pass, CI time increase gradually. Log output takes some times in CI, So someone may want to set :info or :error to loglevel. But we want debug log when CI fails to inspect the root cause. CiLogger output debug log only when CI fails. So we are able to logs and get faster CI.

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
