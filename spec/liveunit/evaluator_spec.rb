require_relative '../spec_helper.rb'

RSpec.configure do |c|
  c.order = "random"
  c.before(:all) do
      FileUtils.mkdir_p(File.expand_path('./livetest'))
      FileUtils.copy(File.expand_path("./spec/livetest/test_fixture.rb"), File.expand_path("./livetest/test_fixture.rb"))
  end
  c.after(:all) { FileUtils.rm_r(File.expand_path('./livetest')) }
end

describe "Evaluator" do
  let(:fix) { Fixture.new }

  describe "#evaluate" do
    it "returnes true for passed example" do
      fix.hello
      snapshot = fix.evaluator.liveunit_snapshot("hello")
      expect(fix.evaluator.evaluate(snapshot)).to eq(true)
    end
    it "returnes false for failed example" do
      #call it first to get a snapshot
      fix.calculate(40)
      snapshot = fix.evaluator.liveunit_snapshot("calculate")
      expect(fix.evaluator.evaluate(snapshot)).to eq(false)
    end
    it "returnes true for untested example" do
      fix.myarray
      snapshot = fix.evaluator.liveunit_snapshot("myarray")
      expect(fix.evaluator.evaluate(snapshot)).to eq(true)
    end
  end

  describe "#liveunit_snapshot" do
    let(:fix) { Fixture.new }
    it "makes correct object snapshots" do
      #call it first to get a snapshot
      fix.hello
      snapshot = fix.evaluator.liveunit_snapshot("hello")
      #unit name
      expect(snapshot[0]).to eq("hello")
      #suite
      expect(snapshot[1]).to eq(Fixture)
      #env
      expect(snapshot[2].length).to eq(8)
      #value returned
      expect(snapshot[3]).to eq("hi")
    end
  end

  describe "#create_reporter" do
    let(:fix) { Fixture.new }
    it "creates reporters successfully" do
      expect(fix.evaluator.create_reporter(Fixture, NilReporter)).to be_an_instance_of(LiveUnit::FixtureReporter)
    end
  end


end
