module CiLogger
  module Minitest
    module Integration
      def before_teardown
        super
        if !Rails.application.config.ci_logger.enabled
          Registry.sync
        elsif passed? || skipped?
          Registry.clear
        else
          Registry.sync
        end
      end
    end
  end
end
class ActiveSupport::TestCase
  include CiLogger::Minitest::Integration
end
