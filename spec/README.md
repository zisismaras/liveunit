# Testing
Rspec has been used to test the tests(!) to avoid mix ups with the included patched minitest.

The autoloader is bad so each example should be run individually from the root directory or it will fail :  
```
rspec spec/liveunit/evaluator_spec.rb 
rspec spec/liveunit/liveunit_spec.rb 
```
