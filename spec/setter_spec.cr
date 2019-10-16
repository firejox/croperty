require "./spec_helper"

@[Croperty::Setter(setter1: Int32)]
@[Croperty::Setter(setter2: Int32, init: 1234)]
private class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::Setter do
  it "only has setter method" do
    foo = TestedObject.new
    foo.responds_to?(:setter1).should be_false
    foo.responds_to?(:setter1=).should be_true
  end

  it "can use with initialization" do
    foo = TestedObject.new
    foo.@setter2.should eq(1234)
  end
end
