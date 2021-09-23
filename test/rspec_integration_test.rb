require "test_helper"

class RspecIntegrationTest < ActiveSupport::TestCase
  LOGFILE_PATH = Rails.root.join('log/test.log').to_s

  setup do
    RSpec.configuration.output_stream = File.open('/dev/null', 'w')
    File.exist?(LOGFILE_PATH) && File.truncate(LOGFILE_PATH, 0)
    @reporter = RSpec.configuration.formatter_loader.reporter
  end

  test "success test doesn't write logs on CiLogger enabled" do
    group = RSpec.describe 'hello', type: :request
    group.example do
      get '/users'
      expect(response.status).to eq 200
    end
    group.run(@reporter)
    assert File.empty?(LOGFILE_PATH)
  end

  test "failure test write logs on CiLogger enabled" do
    group = RSpec.describe 'hello', type: :request
    group.example do
      get '/users'
      expect(response.status).to eq 500
    end
    group.run(@reporter)
    assert_not File.empty?(LOGFILE_PATH)
  end

  test "exception test write logs on CiLogger enabled" do
    group = RSpec.describe 'hello', type: :request
    group.example { raise }
    group.run(@reporter)
    assert_not File.empty?(LOGFILE_PATH)
  end

  test "success test doesn't write logs on CiLogger disabled" do
    Rails.application.config.ci_logger.enabled = false
    group = RSpec.describe 'hello', type: :request
    group.example do
      get '/users'
      expect(response.status).to eq 200
    end
    group.run(@reporter)
    assert File.empty?(LOGFILE_PATH)
    Rails.application.config.ci_logger.enabled = true
  end

  test "failure test write logs on CiLogger disabled" do
    Rails.application.config.ci_logger.enabled = false
    group = RSpec.describe 'hello', type: :request
    group.example do
      get '/users'
      expect(response.status).to eq 500
    end
    group.run(@reporter)
    assert File.empty?(LOGFILE_PATH)
    Rails.application.config.ci_logger.enabled = true
  end

  test "exception test write logs on CiLogger disabled" do
    Rails.application.config.ci_logger.enabled = false
    group = RSpec.describe 'hello', type: :request
    group.example { raise }
    group.run(@reporter)
    assert File.empty?(LOGFILE_PATH)
    Rails.application.config.ci_logger.enabled = true
  end
end
