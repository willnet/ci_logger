module CiLogger
  class Railtie < ::Rails::Railtie
    config.ci_logger = ActiveSupport::OrderedOptions.new
    config.ci_logger.enabled = false

    config.before_initialize do
      if config.ci_logger.enabled
        Rails.logger = CiLogger::Logger.new(Rails.logger)

        RSpec.configure do |config|
          config.add_formatter 'progress'
          config.add_formatter ::CiLogger::Formatter
          config.before do |example|
            Rails.logger.debug("start example at #{example.location}")
          end
        end
      end
    end
  end
end
