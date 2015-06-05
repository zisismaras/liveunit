require "after_do"
require_relative "liveunit/evaluator.rb"
require_relative "liveunit/loader.rb"
require_relative "liveunit/print_reporter.rb"

##
#Core parent module, everything lives inside it
module LiveUnit
  extend self
  ##
  #inject the required liveunit's methods when the module is included
  def self.included(klass)
    unless klass.instance_methods.include?(:evaluator)
      body = Proc.new { |reporter=LiveUnit::PrintReporter|
        @_liveunit_evaluator = LiveUnit::Evaluator.new(self)
        if self.methods.select{|m| m.match(/^liveunit/)}.empty?
          LiveUnit.track_methods(self, first_pass=true)
        else
          LiveUnit.track_methods(self, first_pass=false)
        end
        @_liveunit_reporter = @_liveunit_evaluator.create_reporter(klass, reporter)
        LiveUnit::Loader.new.require_directory("./livetest")
      }
      klass.send(:define_method, :evaluate_me, body)
      body = Proc.new { @_liveunit_evaluator }
      klass.send(:define_method, :evaluator, body)
      body = Proc.new { @_liveunit_reporter }
      klass.send(:define_method, :reporter, body)
    end
  end

  ##
  #tracks all the object's methods
  #if we have already modified the class, don't redefine again and just create the callbacks
  def track_methods(obj, first_pass)
    my_methods =  obj.class.instance_methods(false)
    my_methods.delete(:evaluate_me)
    my_methods.delete(:evaluator)
    my_methods.delete(:reporter)
    my_methods.delete(:loader)
    if first_pass
      my_methods.each do |m|
        redefine(obj, m)
        create_callbacks_for(obj, m)
      end
    else
      my_methods.each do |m|
        create_callbacks_for(obj, m)
      end
    end
  end

  private
  ##
  #we alias the method and then wrap it as proc we can keep track of the returned value
  def redefine(obj, meth)
    obj.class.class_eval { alias_method "liveunit_#{meth}".to_sym, meth }
    obj.class.class_eval <<-END_EVAL, __FILE__, __LINE__ + 1
      def #{meth}(*args)
        method_proc = self.method("liveunit_#{meth}".to_sym).to_proc
        @liveunit_#{meth} = method_proc.call(*args)
        #@liveunit_#{meth}_binding = method_proc.binding
        @_liveunit_snapshot =  @_liveunit_evaluator.liveunit_snapshot("#{meth}")
        @liveunit_#{meth}
      end
    END_EVAL
  end

  ##
  #creates <evaluate> and <report> callbacks to be run after the method has finished
  def create_callbacks_for(obj, meth)
    obj.class.extend AfterDo
    obj.class.after "#{meth.to_sym}" do
      snapshot = obj.instance_variable_get("@_liveunit_snapshot")
      obj.instance_variable_get("@_liveunit_evaluator").evaluate(snapshot)
      obj.instance_variable_get("@_liveunit_reporter").report
    end
  end

end

#replace the eval

#body_proc = Proc.new { |*args|
  #method_proc = obj.class.method("liveunit_#{meth}".to_sym).to_proc
  #instance_variable_set("@liveunit_#{meth}".to_sym, method_proc.call(*args))
  #instance_variable_set("@liveunit_#{meth}_snapshot".to_sym, @_liveunit_evaluator.liveunit_snapshot)
  ##instance_variable_set("@liveunit_#{meth}_binding".to_sym, method_proc.binding)
 # instance_variable_get("@liveunit_#{meth}".to_sym)
#}
#obj.class.send(:define_method, "#{meth}".to_sym, body_proc)
