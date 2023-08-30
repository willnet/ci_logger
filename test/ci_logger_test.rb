require "test_helper"

class CiLoggerTest < ActiveSupport::TestCase
  test "CiLogger.new return CiLogger::Logger instance" do
    logger = CiLogger.new(Logger.new(STDOUT))
    assert_instance_of CiLogger::Logger, logger
  end
end
