module LiveUnit
  ##
  #subclass this to create custom reporters
  class Reporter
    attr_accessor :liveunit_assertions, :liveunit_passes, :liveunit_fails, :liveunit_results

    def initialize
      @liveunit_assertions = 0
      @liveunit_passes = 0
      @liveunit_fails = 0
      @liveunit_results = []
    end
    ##
    #gets called after each evaluation to store the result
    def report
      #overwrite me
    end

    private
    ##
    #returns the results and also clears them for the next run
    def results
      re = @liveunit_results
      @liveunit_results = []
      re
    end
  end
end
