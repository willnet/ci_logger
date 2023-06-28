module CiLogger
  class Railtie < ::Rails::Railtie
    config.ci_logger = ActiveSupport::OrderedOptions.new
    config.ci_logger.enabled = false

    config.before_initialize do
      if Rails.application.config.ci_logger.enabled
        Rails.logger = CiLogger::Logger.new(Rails.logger)
        begin
          require "rspec/core"
          require "ci_logger/rspec/integration"
        rescue LoadError
          # do nothing
        end

        begin
          require "active_support/test_case"
          require "ci_logger/minitest/integration"
        rescue LoadError
          # do nothing
        end
      end
    end
  end
end
