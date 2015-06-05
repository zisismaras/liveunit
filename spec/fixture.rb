require_relative "../lib/liveunit.rb"
class Fixture
  include LiveUnit

  def initialize
    evaluate_me(NilReporter)
    @myvar, @anothervar = 15, 3.14
  end

  def calculate(num)
    num + 10
  end

  def hello
    "hi"
  end

  def myarray
    ["dog", "cat", "thing"]
  end

end


require_relative "../lib/liveunit/reporter.rb"
class NilReporter < LiveUnit::Reporter
  def report
    #report nothing
  end
end


