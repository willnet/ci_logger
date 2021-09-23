require "ci_logger/version"
require "ci_logger/railtie"
require "ci_logger/logger"

module CiLogger
  begin
    require "rspec/rails"

    class StatusFormatter
      RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed

      def initialize(_out)
        @out = _out
      end

      def example_failed(notification)
        if Rails.application.config.ci_logger.enabled
          example = notification.example
          Rails.logger.debug("finish example at #{example.location}")
          Rails.logger.sync
        else
          Rails.logger.clear
        end
      end

      def example_passed(_notification)
        Rails.logger.clear
      end

      def example_pending(_notification)
        Rails.logger.clear
      end
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
end
