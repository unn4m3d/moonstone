require "../runner"
require "../../moonstone"
require "option_parser"

args = {} of String => String
colorize = true

module Moonstone
  class_property runner = Moonstone::Runner.new STDOUT
end

OptionParser.parse! do |parser|
  parser.banner = "Usage : #{PROGRAM_NAME} [OPTIONS] [--] [FLAGS]"
  parser.on("-o KEYVALUE", "--option KEYVALUE", "Uses KEYVALUE as argument (KEYVALUE is in form KEY=VALUE)") do |s|
    key, _, value = s.partition('=')
    args[key] = value
  end

  parser.on("-m", "--monochrome", "Do not use colorized output") do
    Colorize.enabled = false
  end

  parser.on("-f FLAG", "--flag FLAG", "Define FLAG") do |f|
    Moonstone.runner.flags << f
  end

  parser.unknown_args do |_, flags|
    Moonstone.runner.flags += flags
  end
end



delegate flag?, to: Moonstone.runner

at_exit do
  begin
    Moonstone.runner.run args
  rescue e
    Moonstone.runner.print_exception e
    exit 1
  end
end
