require_relative '../spec_helper.rb'

RSpec.configure do |c|
  c.order = "random"
  c.before(:all) do
      FileUtils.mkdir_p(File.expand_path('./livetest'))
      FileUtils.copy(File.expand_path("./spec/livetest/test_fixture.rb"), File.expand_path("./livetest/test_fixture.rb"))
  end
  c.after(:all) { FileUtils.rm_r(File.expand_path('./livetest')) }
end

describe "LiveUnit" do
  let(:fix) { Fixture.new }

  it "properly prepares the object" do
    expect(fix).to respond_to(:evaluate_me, :evaluator, :reporter)
  end
  it "properly redefines all methods" do
    expect(fix).to respond_to(:calculate, :hello, :myarray)
    expect(fix).to respond_to(:liveunit_calculate, :liveunit_hello, :liveunit_myarray)
  end
  it "has redefined methods that work" do
    expect(fix.hello).to eq("hi")
    expect(fix.liveunit_hello).to eq("hi")
    expect(fix.liveunit_hello).to eq(fix.hello)
  end
  it "has a reporter up and running" do
    expect(NilReporter).to eq(LiveUnit::FixtureReporter.superclass)
    expect(LiveUnit::Reporter).to eq(NilReporter.superclass)
    expect(fix.reporter).to be_an_instance_of(LiveUnit::FixtureReporter)
  end
end
