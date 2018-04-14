module Moonstone
  abstract class Task
    class FailedException < ::Exception
    end

    @runner : Runner? = nil

    def runner
      @runner.not_nil!
    end

    def runner=(@runner)
    end


    delegate log, info, debug, error, warn, fatal, to: runner.logger

    def scope(&block)
      runner.scope_depth += 1
      begin
        yield
      ensure
        runner.scope_depth -= 1
      end
    end

    def shell(cmd)
      info cmd.colorize(:green), "Shell"
      unless system cmd
        raise FailedException.new("Shell command returned non-zero exit code #{$?}")
      end
    end

    def execute(name : String, &block)
      info name.colorize(:blue), "Crystal"
      scope &block
    rescue e
      raise FailedException.new("An exception has been raised", e)
    end

    abstract def run(args : Hash(String, String))
  end
end
