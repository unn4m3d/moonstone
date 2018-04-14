require "logger"
require "colorize"
require "./task"

module Moonstone
  class Runner
    property tasks = [] of Task
    property flags = [] of String

    def flag?(f)
      flags.includes? f.to_s
    end

    property logger : Logger
    property scope_depth = 0

    private def sev_to_color(s)
      case s
      when .warn?
        :yellow
      when .error?, .fatal?
        :red
      when .info?
        :green
      when .debug?
        :blue
      else
        :white
      end
    end

    def initialize(@stdout : IO)
      @logger = Logger.new stdout
      @logger.formatter = Logger::Formatter.new do |sev, time, prog, msg, io|
        label = sev.to_s
        pname = prog.empty? ? "" : "[#{prog}]"

        io << "  " * @scope_depth
        io << "[#{label.colorize sev_to_color sev}]" << pname << " " << msg
      end
      @logger.level = Logger::DEBUG
    end

    def print_exception(e)
      @logger.fatal e.inspect_with_backtrace
      if e.cause
        @logger.fatal "Caused by:"
        print_exception e.cause.not_nil!
      end
    end

    def run(args)
      tasks.each do |t|
        scope_depth = 0
        t.runner = self
        t.run args
      end
    end
  end
end
