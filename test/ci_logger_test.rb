require "test_helper"

class CiLoggerTest < ActiveSupport::TestCase
  LOGFILE_PATH = '/tmp/ciloggertest.log'

  setup do
    log = Logger.new(LOGFILE_PATH)
    @logger = CiLogger::Logger.new(log)
  end

  teardown do
    @logger.clear
    File.unlink(LOGFILE_PATH)
  end

  test "CiLogger#debug doesn't output immediately" do
    @logger.debug 'ci_logger!'

    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger#sync output before it write" do
    @logger.debug 'ci_logger!'
    @logger.sync
    assert File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger#sync doesn't output log if it's loglevel is lower than setting" do
    @logger.level = :info
    @logger.debug 'ci_logger!'
    @logger.sync
    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger accepts methods original logger has" do
    # tagged is a extension method of the Rails Logger
    Rails.logger.tagged('hello') { |l| l.debug('world') }
  end
end
