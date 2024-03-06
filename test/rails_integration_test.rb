require "test_helper"

class RailsIntegrationTest < ActiveSupport::TestCase
  if Rails.gem_version >= Gem::Version.new('7.1')
    test "Rails.logger is a BroadcastLogger and it has instances of CiLogger" do
      assert Rails.logger.is_a?(ActiveSupport::BroadcastLogger)
      assert Rails.logger.instance_variable_get(:@broadcasts).all? { |logger| logger.is_a?(CiLogger::Logger) }
    end
  else
    test "Rails.logger is an CiLogger" do
      assert Rails.logger.is_a?(CiLogger::Logger)
    end
  end
end
