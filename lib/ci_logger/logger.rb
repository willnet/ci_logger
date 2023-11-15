require "ci_logger/registry"

module CiLogger
  class Logger
    def initialize(original)
      @original = original
      Registry.register(self)
    end

    def sync
      temporary_log.each do |l|
        @original.add(l[:severity], l[:message], l[:progname])
      end
      temporary_log.clear
    end

    def clear
      temporary_log.clear
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

    def debug(progname = nil, &block)
      add(::Logger::DEBUG, nil, progname, &block)
    end

    def info(progname = nil, &block)
      add(::Logger::INFO, nil, progname, &block)
    end

    def warn(progname = nil, &block)
      add(::Logger::WARN, nil, progname, &block)
    end

    def error(progname = nil, &block)
      add(::Logger::ERROR, nil, progname, &block)
    end

    def fatal(progname = nil, &block)
      add(::Logger::FATAL, nil, progname, &block)
    end

    def unknown(progname = nil, &block)
      add(::Logger::UNKNOWN, nil, progname, &block)
    end

    private

    def temporary_log
      @temporary_log ||= []
    end

    def method_missing(...)
      @original.send(...)
    end

    def respond_to_missing?(...)
      @original.respond_to?(...)
    end
  end
end
