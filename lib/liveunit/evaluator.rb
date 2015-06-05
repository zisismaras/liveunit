module LiveUnit
  ##
  #core evaluator class, gets instantiated when the module is included
  class Evaluator

    def initialize(obj)
      @obj = obj
    end
    ##
    #this will be run as a callback after every method we want to evaluate has finished,
    #uses the snapshot taken, runs the corresponding test file and stores the results
    def evaluate(snapshot)
      unit, suite, obj_env, myreturn = snapshot
      test = "test_#{unit}"
      if Module.const_defined?("Test#{suite}")
        test_class = Module.const_get("Test#{suite}").new(obj_env, @obj.clone, myreturn)
        test_class.send(test)
        unless test_class.passed?
          @obj.reporter.liveunit_results.push(
          :case => "#{test_class.class}##{test}",
          :msg => test_class.msg,
          :expectation => test_class.result_msg,
          :env => obj_env
          )
          @obj.reporter.liveunit_fails += 1
        else
          @obj.reporter.liveunit_passes += 1
        end
        @obj.reporter.liveunit_assertions += 1
        test_class.passed?
      else
        true
      end
    end

    ##
    #captures the state that will be passed later to <evaluate>
    def liveunit_snapshot(unit)
      suite = @obj.class
      instanced = @obj.instance_variables
      consts = @obj.class.constants
      globals = global_variables
      classed = @obj.class.class_variables
      obj_env = set_env(@obj, unit, instanced, consts, globals, classed)
      myreturn =@obj.instance_variable_get("@liveunit_#{unit}".to_sym)
      [unit, suite, obj_env, myreturn]
    end

    ##
    #creates the reporter for each object that will be getting evaluated
    def create_reporter(me, rep)
      if LiveUnit.const_defined?("#{me}Reporter")
        LiveUnit.const_get("#{me}Reporter").new
      else
        LiveUnit.const_set("#{me}Reporter", Class.new(rep)).new
      end
    end

    private
    ##
    #returnes the current object's state env, exluding liveunit specific variables
    def set_env(obj, unit, instanced, consts, globals, classed)
      my_env = {}
      instanced.delete(:@_liveunit_evaluator)
      instanced.delete(:@_liveunit_snapshot)
      instanced.delete(:@_liveunit_reporter)
      instanced.delete("@liveunit_#{unit}".to_sym)
      instanced.each do |varname|
        my_env.merge!({varname => obj.instance_variable_get(varname)})
      end
      consts.each do |con|
        my_env.merge!({con => obj.class.const_get(con)})
      end
      classed.each do |varname|
        my_env.merge!({varname => obj.class.class_variable_get(varname)})
      end
      my_env
    end

  end
end
