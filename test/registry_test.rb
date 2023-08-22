require "test_helper"

class RegistryTest < ActiveSupport::TestCase
  LOGFILE_PATH_1 = '/tmp/ciloggertest_1.log'
  LOGFILE_PATH_2 = '/tmp/ciloggertest_2.log'

  setup do
    log1 = Logger.new(LOGFILE_PATH_1)
    log2 = Logger.new(LOGFILE_PATH_2)
    @logger1 = CiLogger::Logger.new(log1)
    @logger2 = CiLogger::Logger.new(log2)
  end

  test "Registry#sync syncs all registered loggers" do
    @logger1.debug 'ci_logger1'
    @logger2.debug 'ci_logger2'
    CiLogger::Registry.sync
    assert File.read(LOGFILE_PATH_1).match?('ci_logger1')
    assert File.read(LOGFILE_PATH_2).match?('ci_logger2')
  end

  test "Registry#debug calls debug method of all registered loggers" do
    mock1 = Minitest::Mock.new.expect(:call, nil, ['ci_logger!'])
    mock2 = Minitest::Mock.new.expect(:call, nil, ['ci_logger!'])
    @logger1.stub(:debug, mock1) do
      @logger2.stub(:debug, mock2) do
        CiLogger::Registry.debug('ci_logger!')
      end
    end

    mock1.verify
    mock2.verify
  end

  teardown do
    CiLogger::Registry.clear
    File.unlink(LOGFILE_PATH_1)
    File.unlink(LOGFILE_PATH_2)
  end
end
