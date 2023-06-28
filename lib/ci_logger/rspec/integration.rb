require "ci_logger/rspec/example_group_methods"

RSpec.configure do |config|
  config.include CiLogger::Rspec::ExampleGroupMethods

  config.prepend_before do |example|
    next unless Rails.application.config.ci_logger.enabled

    Rails.logger.debug("start example at #{example.location}")
  end

  config.append_after do |example|
    if !Rails.application.config.ci_logger.enabled
      Rails.logger.sync
    elsif passed?
      Rails.logger.clear
    else
      Rails.logger.debug("finish example at #{example.location}")
      Rails.logger.sync
    end
  end
end
