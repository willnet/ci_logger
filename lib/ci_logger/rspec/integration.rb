require "ci_logger/rspec/example_group_methods"

RSpec.configure do |config|
  config.include CiLogger::Rspec::ExampleGroupMethods

  config.prepend_before do |example|
    next unless Rails.application.config.ci_logger.enabled

    CiLogger::Registry.debug("start example at #{example.location}")
  end

  config.append_after do |example|
    if !Rails.application.config.ci_logger.enabled
      CiLogger::Registry.sync
    elsif passed?
      CiLogger::Registry.clear
    else
      CiLogger::Registry.debug("finish example at #{example.location}")
      CiLogger::Registry.sync
    end
  end
end
