# LiveUnit

Example implementation to test my experiment on live unit testing.  
Check the blog post here.  

##Installing
```ruby
gem install liveunit
```
##Using
Include the module and place the evaluate_me method call in the entry point of your object(eg. the `initialize` method)  

```ruby
require 'liveunit'

class Example
  include LiveUnit
  def initialize
    evaluate_me #!
    @myvar = 15
  end
  def calculate(num)
    num + 10
  end
end

ex = Example.new
puts ex.calculate(40)
```

Then let's create a test for our calculate method in a `livetest/test_example.rb` file:  
```ruby
require 'liveunit/testcase'

class TestExample < LiveUnit::TestCase
  #doomed to fail
  def test_calculate
    msg "Result should be greater than 400 when @myvar==15"
    assert_equal(15, state[:@myvar])
    assert_operator myreturn, :>=, 400
  end
end
``` 

Run the program and you should see this :
```
Failure : TestExample#test_calculate
Message : Result should be greater than 400 when @myvar==15
Expected 50 to be >= 400.
``` 

## Features/Problems
The minitest's assertion system is used so most assert operations should work.  
Autoloading and discovering is quite dumb so certain conventions must be followed:  

1. Test files should be placed in a /livetest folder in the program's root directory.
2. Test file name should be in a format of `test_objectname.rb`.
3. Unit test suite has to be in a format of `class TestObjectName < LiveUnit::TestCase`
4. Unit test method should be named `def test_method_name`  

It has not been tested with more complex things like rack applications or anything that actually matters, only simple plain ruby programs.  
Runtime overhead is significant.  

## Creating custom reporters
By default a reporter that writes to stdout will be used but it can be easily changed.  
Let's create a reporter that writes to a log file, just subclass `LiveUnit::Reporter` and overwrite the `report` method.
The `report` method gets executed after each test and the results are available in the `results` method.   
```ruby
require 'logger'
require 'liveunit/reporter'

class MyReporter < LiveUnit::Reporter
  def initialize
    @logger = Logger.new('logs')
    super
  end

  def report
    results.each do |re|
      @logger.error("Case : #{re[:case]} Failed.")
      @logger.error("Message : #{re[:msg]}")
      @logger.error("Enviroment : #{re[:env]}")
      @logger.error("Expectation : #{re[:expectation]}")
    end
  end
end
``` 
then just pass it to the evaluate_me method : `evaluate_me(MyReporter)`  

## Final Notice
Make sure you also read the blog post if you are interested.  
This is not meant to be used in anything serious(it can't anyway)  
It is just an experimental testing tool and will be probably die soon.
