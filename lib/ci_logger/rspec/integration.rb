require "ci_logger/rspec/example_group_methods"

RSpec.configure do |config|
  config.include CiLogger::Rspec::ExampleGroupMethods

  config.prepend_before do |example|
    next if CiLogger.disabled?

    CiLogger::Registry.debug("start example at #{example.location}")
  end

  config.append_after do |example|
    if CiLogger.disabled?
      CiLogger::Registry.sync
    elsif passed?
      CiLogger::Registry.clear
    else
      CiLogger::Registry.debug("finish example at #{example.location}")
      CiLogger::Registry.sync
    end
  end
end
