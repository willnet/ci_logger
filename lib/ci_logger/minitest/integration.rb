module CiLogger
  module Minitest
    module Integration
      def before_teardown
        super
        if !Rails.application.config.ci_logger.enabled
          Rails.logger.sync
        elsif passed? || skipped?
          Rails.logger.clear
        else
          Rails.logger.sync
        end
      end
    end
  end
end
class ActiveSupport::TestCase
  include CiLogger::Minitest::Integration
end
