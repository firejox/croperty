require "./spec_helper"

@[Croperty::MultiSetter(setter1: Int32, setter2: Int32)]
private class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::MultiSetter do
  context "variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Setter" do
      foo = TestedObject.new

      foo.responds_to?(:setter1).should be_false
      foo.responds_to?(:setter1=).should be_true

      foo.responds_to?(:setter2).should be_false
      foo.responds_to?(:setter2=).should be_true
    end
  end
end
