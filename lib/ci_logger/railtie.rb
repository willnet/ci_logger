module CiLogger
  class Railtie < ::Rails::Railtie
    config.ci_logger = ActiveSupport::OrderedOptions.new
    config.ci_logger.enabled = false

    config.before_initialize do
      Rails.logger = CiLogger::Logger.new(Rails.logger) if config.ci_logger.enabled
    end
  end
end
