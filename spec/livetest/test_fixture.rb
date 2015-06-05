require_relative "../lib/liveunit/testcase.rb"

class TestFixture < LiveUnit::TestCase

  #this fails
  def test_calculate
    msg "Result should be greater than 400 when @myvar=35"
    assert_equal(35, state[:@myvar])
    assert_operator myreturn, :>=, 400
  end
  #this passes
  def test_hello
    msg "Result should be hi"
    assert_equal("hi", myreturn)
  end
end
