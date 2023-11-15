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

  test "CiLogger::Logger#info doesn't output immediately" do
    @logger.info 'ci_logger!'

    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger#sync output before it write" do
    @logger.info 'ci_logger!'
    @logger.sync
    assert File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger supports block" do
    @logger.info do
      'ci_logger!'
    end
    @logger.sync
    assert File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger#sync doesn't output log if original loglevel is higher" do
    @logger.debug 'ci_logger!'
    @logger.sync
    assert_not File.read(LOGFILE_PATH).match?('ci_logger!')
  end

  test "CiLogger::Logger accepts methods original logger has" do
    # tagged is a extension method of the Rails Logger
    Rails.logger.tagged('hello') { |l| l.info('world') }
  end

  test "CiLogger::Logger uses formatter that original logger has" do
    assert_equal 'hoge', @logger.formatter.hoge
  end
end
