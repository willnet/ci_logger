require "ci_logger/version"
require "ci_logger/railtie"
require "ci_logger/logger"

module CiLogger
end

begin
  require "rspec"

  RSpec.configure do |config|
    config.around do |example|
      if CiLogger.enabled
        Rails.logger.debug("start example at #{example.location}")
        example.run
        if example.execution_result.status == :failed
          Rails.logger.debug("finish example at #{example.location}")
          Rails.logger.sync
        else
          Rails.logger.clear
        end
      end
    end
  end
rescue LoadError
end

