require "ci_logger/registry"

module CiLogger
  class Logger < ::Logger
    def initialize(original)
      @original = original
      @original_level = @original.level
      @original.level = :debug
      self.level = :debug
      Registry.register(self)
    end

    def sync
      temporary_log.each do |l|
        if @level <= l[:severity]
          @original.add(l[:severity], l[:message], l[:progname])
        end
      end
      temporary_log.clear
    end

    def sync_with_original_level
      @original.level = @original_level
      sync
    ensure
      @original.level = :debug
    end

    def clear
      temporary_log.clear
    end

    def formatter
      @original.formatter
    end

    def formatter=(f)
      @original.formatter = f
    end

    private

    def temporary_log
      @temporary_log ||= []
    end

    def add(severity, message = nil, progname = nil)
      if progname.nil?
        progname = @progname
      end
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
      temporary_log << { severity: severity, message: message, progname: progname }
    end

    def method_missing(symbol, *args, &block)
      @original.send(symbol, *args, &block)
    end

    def respond_to_missing?(symbol, include_all)
      @original.respond_to?(symbol, include_all)
    end
  end
end
