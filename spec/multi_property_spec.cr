require "./spec_helper"

@[Croperty::MultiProperty(prop1: Int32, prop2?: Int32, prop3!: Int32)]
private class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::MultiProperty do
  context "all variables have setter" do
    foo = TestedObject.new
    foo.responds_to?(:prop1=).should be_true
    foo.responds_to?(:prop2=).should be_true
    foo.responds_to?(:prop3=).should be_true
  end

  context "default mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Property" do
      foo = TestedObject.new
      foo.responds_to?(:prop1).should be_true

      typeof(foo.@prop1).should eq(Int32)
      typeof(foo.prop1).should eq(Int32)
    end
  end

  context "query mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Property" do
      foo = TestedObject.new

      foo.responds_to?(:prop2?).should be_true
      foo.responds_to?(:prop2).should be_false

      foo.@prop2.should be_nil
      foo.prop2?.should be_nil

      typeof(foo.prop2?).should eq(Int32?)
      typeof(foo.@prop2).should eq(Int32?)
    end
  end

  context "exclaim mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Property" do
      foo = TestedObject.new

      foo.responds_to?(:prop3?).should be_true
      foo.responds_to?(:prop3).should be_true

      foo.@prop3.should be_nil
      foo.prop3?.should be_nil

      expect_raises NilAssertionError do
        foo.prop3
      end

      typeof(foo.prop3?).should eq(Int32?)
      typeof(foo.prop3).should eq(Int32)
      typeof(foo.@prop3).should eq(Int32?)
    end
  end
end
