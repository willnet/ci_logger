require "test_helper"

class MinitestIntegrationTest < ActiveSupport::TestCase
  test_class = Class.new(ActiveSupport::TestCase) do
    # Avoid the prefix "test_" as it makes the test subject to the CiLogger itself.
    def sample_success
      Rails.logger.debug 'hoge'
      assert true
    end

    def sample_skip
      Rails.logger.debug 'hoge'
      skip "not yet"
    end

    def sample_failure
      Rails.logger.debug 'hoge'
      assert false
    end
  end

  LOGFILE_PATH = Rails.root.join('log/test.log').to_s

  setup do
    File.exist?(LOGFILE_PATH) && File.truncate(LOGFILE_PATH, 0)
  end

  test "success test doesn't write logs on CiLogger enabled" do
    test_class.new('sample_success').run

    assert File.empty?(LOGFILE_PATH)
  end

  test "skip test doesn't write logs on CiLogger enabled" do
    test_class.new('sample_skip').run

    assert File.empty?(LOGFILE_PATH)
  end

  test "failure test writes logs on CiLogger enabled" do
    begin
      test_class.new('sample_failure').run
    rescue Minitest::Assertion
      # do nothing
    end
    assert_not File.empty?(LOGFILE_PATH)
  end
end
