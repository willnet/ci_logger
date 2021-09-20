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

  RSpec.configure do |c|
    c.add_formatter StatusFormatter
  end
rescue LoadError
end

