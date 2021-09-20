require "ci_logger/version"
require "ci_logger/railtie"
require "ci_logger/logger"

module CiLogger
end

begin
  require "rspec"

  class StatusFormatter
    RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed

    def initialize(_out)
      @out = _out
    end

    def example_finished(notification)
      example = notification.example

      if example.execution_result.status == :failed
        Rails.logger.debug("finish example at #{example.location}")
        Rails.logger.sync
      else
        Rails.logger.clear
      end
    end
    alias example_passed example_finished
    alias example_pending example_finished
    alias example_failed example_finished
  end

  RSpec.configure do |config|
    config.add_formatter 'progress'
    config.add_formatter StatusFormatter

    config.before do |example|
      if Rails.application.config.ci_logger.enabled
        Rails.logger.debug("start example at #{example.location}")
      end
    end
  end
rescue LoadError
end

