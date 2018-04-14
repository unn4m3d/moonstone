require "./src/moonstone/config/default"

class ExampleTask < Moonstone::Task
  @foo : String

  def initialize(@foo)
  end

  def run(args)
    info "ExampleTask started"
    shell "echo '  shell'"
    execute "Doing some stuff" do
      info "Foo is #{@foo}, args : #{args}"
    end

    execute "Doing another stuff" do
      warn "Going to raise!"
      if flag? "no-raise"
        debug "That was a joke! Hahaha"
      else
        if @foo =~ /^void/
          warn "Pshhh"
        else
          raise "Boo!"
        end
      end
    end
  end
end

def example(**args)
  Moonstone.runner.tasks << ExampleTask.new(args[:foo]? || "void and null")
end

example
example foo: "void and n"
example foo: "crystal is the best!"
