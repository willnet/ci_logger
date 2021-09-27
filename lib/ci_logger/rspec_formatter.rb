require "rspec/core"

module CiLogger
  class RspecFormatter
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
        Rails.logger.sync_with_original_level
      end
    end

    def example_passed(_notification)
      if Rails.application.config.ci_logger.enabled
        Rails.logger.clear
      else
        Rails.logger.sync_with_original_level
      end
    end

    def example_pending(_notification)
      if Rails.application.config.ci_logger.enabled
        Rails.logger.clear
      else
        Rails.logger.sync_with_original_level
      end
    end
  end
end
