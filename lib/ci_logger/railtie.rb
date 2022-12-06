module CiLogger
  class Railtie < ::Rails::Railtie
    config.ci_logger = ActiveSupport::OrderedOptions.new
    config.ci_logger.enabled = false
    config.ci_logger.start_example_log = "start example at %{location}"
    config.ci_logger.finish_example_log = "finish example at %{location}"

    config.before_initialize do
      if config.ci_logger.enabled
        Rails.logger = CiLogger::Logger.new(Rails.logger)
        require "ci_logger/rspec_formatter"

        RSpec.configure do |config|
          config.add_formatter 'progress' if config.formatters.empty?
          config.add_formatter ::CiLogger::RspecFormatter
          config.before do |example|
            Rails.logger.debug(config.ci_logger.start_example_log.gsub("%{location}", example.location))
          end
        end
      end
    end
  end
end
