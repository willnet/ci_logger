require "ci_logger/version"
require "ci_logger/railtie"
require "ci_logger/logger"

module CiLogger
  class << self
    def new(original)
      Logger.new(original)
    end

    def enabled?
      Rails.application.config.ci_logger.enabled
    end

    def disabled?
      !enabled?
    end
  end
end
