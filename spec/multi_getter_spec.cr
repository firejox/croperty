require "./spec_helper"

@[Croperty::MultiGetter(getter1: Int32, getter2?: Int32, getter3!: Int32)]
private class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::MultiGetter do
  it "all variables have no setters" do
    foo = TestedObject.new
    foo.responds_to?(:getter1=).should be_false
    foo.responds_to?(:getter2=).should be_false
    foo.responds_to?(:getter3=).should be_false
  end

  context "default mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Getter" do
      foo = TestedObject.new
      foo.responds_to?(:getter1).should be_true

      typeof(foo.@getter1).should eq(Int32)
      typeof(foo.getter1).should eq(Int32)
    end
  end

  context "query mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Getter" do
      foo = TestedObject.new

      foo.responds_to?(:getter2?).should be_true
      foo.responds_to?(:getter2).should be_false

      foo.@getter2.should be_nil
      foo.getter2?.should be_nil

      typeof(foo.getter2?).should eq(Int32?)
      typeof(foo.@getter2).should eq(Int32?)
    end
  end

  context "exclaim mode variable" do
    it "behave as the variable which defined with unintialize option of Croperty::Getter" do
      foo = TestedObject.new

      foo.responds_to?(:getter3?).should be_true
      foo.responds_to?(:getter3).should be_true

      foo.@getter3.should be_nil
      foo.getter3?.should be_nil

      expect_raises NilAssertionError do
        foo.getter3
      end

      typeof(foo.getter3?).should eq(Int32?)
      typeof(foo.getter3).should eq(Int32)
      typeof(foo.@getter3).should eq(Int32?)
    end
  end
end
