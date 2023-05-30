module CiLogger
  class Railtie < ::Rails::Railtie
    config.ci_logger = ActiveSupport::OrderedOptions.new
    config.ci_logger.enabled = false

    config.before_initialize do
      if Rails.application.config.ci_logger.enabled
        Rails.logger = CiLogger::Logger.new(Rails.logger)
        require "rspec/core"
        require "ci_logger/example_group_methods"

        RSpec.configure do |config|
          config.include CiLogger::ExampleGroupMethods

          config.prepend_before do |example|
            next unless Rails.application.config.ci_logger.enabled

            Rails.logger.debug("start example at #{example.location}")
          end

          config.append_after do |example|
            if !Rails.application.config.ci_logger.enabled
              Rails.logger.sync
            elsif passed? || example.skipped?
              Rails.logger.clear
            else
              Rails.logger.debug("finish example at #{example.location}")
              Rails.logger.sync
            end
          end
        end
      end
    end
  end
end
