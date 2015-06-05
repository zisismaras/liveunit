require "minitest/assertions"

module LiveUnit
  ##
  #all liveunit tests will be a child of LiveUnit::TestCase
  #uses the assertion system from Minitest
  class TestCase
    include Minitest::Assertions
    attr_accessor :assertions

    def initialize(obj_env, obj, myreturn)
      @obj_env = obj_env
      @obj = obj
      @myreturn = myreturn
      #for minitest
      @assertions = 0
      @results ||= []
      @last_result ||={}
      @untested = 0
    end
    ##
    #the unit's returned value
    def myreturn
      @myreturn
    end
    ##
    #returns a cloned version of the object where the methods are defined
    def me
      @obj
    end
    ##
    #extra msg string for tests
    def msg(m="")
      @m ||= m
    end
    ##
    #returns true if all our tests has passed
    def passed?
      results.each { |re| return false unless re[:passed] }
      true
    end
    ##
    #expectation messages if our tests have failed
    def result_msg
      msgs = []
      results.each { |re| msgs.push(re[:msg]) unless re[:passed]}
      msgs
    end
    ##
    #the object's enviroment, includes constants, instance and class variables
    def state
      @obj_env
    end
    ##
    #ignore error for not implemented unit tests
    def method_missing(m)
      if m.to_s =~ /test_/
        @untested += 1
      else
        super
      end
    end

  end
end

module Minitest
  module Assertions
    ##
    #overwrite minitest's assert method to store our results instead of raising errors
    def assert test, msg = nil
      self.assertions += 1
      unless test then
        msg ||= "Failed assertion, no message given."
        msg = msg.call if Proc === msg
      end
      @last_result = {:passed => test, :msg => msg}
      @results.push(@last_result)
      @last_result
    end
    def results
      @results
    end
    def last_result
      @last_result
    end
  end
end
