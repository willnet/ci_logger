module CiLogger
  module Registry
    class << self
      def register(logger)
        @loggers ||= []
        @loggers << logger
      end

      def sync
        @loggers.each(&:sync)
      end

      def clear
        @loggers.each(&:clear)
      end

      def debug(...)
        @loggers.each { _1.debug(...) }
      end
    end
  end
end
