module CiLogger
  module Rspec
    module ExampleGroupMethods
      # original from https://github.com/rspec/rspec-rails/blob/229f5f7ca9c0de0c7bca452450416d988f7cf612/lib/rspec/rails/example/system_example_group.rb#L28-L37
      def passed?
        return false if RSpec.current_example.exception
        return true unless defined?(::RSpec::Expectations::FailureAggregator)

        failure_notifier = ::RSpec::Support.failure_notifier
        return true unless failure_notifier.is_a?(::RSpec::Expectations::FailureAggregator)

        failure_notifier.failures.empty? && failure_notifier.other_errors.empty?
      end
    end
  end
end
