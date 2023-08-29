require "test_helper"

class LoggerTest < ActiveSupport::TestCase
  LOGFILE_PATH = '/tmp/ciloggertest.log'

  class TestFormatter < ::Logger::Formatter
    def hoge
      'hoge'
    end
  end

  setup do
    log = Logger.new(LOGFILE_PATH, level: :info)
    log.formatter = TestFormatter.new
    @logger = CiLogger::Logger.new(log)
  end

  teardown do
    @logger.clear
    File.unlink(LOGFILE_PATH)
  end

  test "CiLogger::Logger#debug doesn't output immediately" do
    @logger.debug 'ci_logger!'

    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger#sync output before it write" do
    @logger.debug 'ci_logger!'
    @logger.sync
    assert File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger supports block" do
    @logger.debug do
      'ci_logger!'
    end
    @logger.sync
    assert File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger#sync doesn't output log if it's loglevel is lower than setting" do
    @logger.level = :info
    @logger.debug 'ci_logger!'
    @logger.sync
    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger#sync_with_original_level output before it write if it's level is equal or higher than original logger's one" do
    @logger.debug 'ci_logger!'
    @logger.info 'hello!'
    @logger.sync_with_original_level
    log = File.read(LOGFILE_PATH)
    assert_not log.match?('ci_logger!')
    assert log.match?('hello!')
  end

  test "CiLogger::Logger accepts methods original logger has" do
    # tagged is a extension method of the Rails Logger
    Rails.logger.tagged('hello') { |l| l.debug('world') }
  end

  test "CiLogger::Logger delegates formatter to original logger" do
    assert_equal 'hoge', @logger.formatter.hoge
  end
end
