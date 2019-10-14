require "./spec_helper"

@[Croperty::Property(prop1: Int32)]
@[Croperty::Property(prop2: Int32, init: 1234)]
@[Croperty::Property(prop3: Int32, init: 1234, lazy_init: true)]
@[Croperty::Property(prop4?: Int32)]
@[Croperty::Property(prop5?: Int32, init: 1234)]
@[Croperty::Property(prop6!: Int32)]
@[Croperty::Property(prop7!: Int32, init: 1234)]
class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::Property do
  it "has getter and setter methods" do
    foo = TestedObject.new

    foo.responds_to?(:prop1).should be_true
    foo.responds_to?(:prop1=).should be_true
  end

  context "default mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      typeof(foo.prop1).should eq(Int32)
      typeof(foo.@prop1).should eq(Int32)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.prop2.should eq(1234)
    end

    it "can be used with lazy initialization" do
      foo = TestedObject.new

      foo.@prop3.should be_nil
      foo.prop3.should eq(1234)
      foo.@prop3.should eq(1234)

      typeof(foo.prop3).should eq(Int32)
      typeof(foo.@prop3).should eq(Int32?)
    end
  end

  context "query mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      foo.responds_to?(:prop4?).should be_true
      foo.responds_to?(:prop4).should be_false

      foo.@prop4.should be_nil
      foo.prop4?.should be_nil

      typeof(foo.prop4?).should eq(Int32?)
      typeof(foo.@prop4).should eq(Int32?)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.@prop5.should eq(1234)
      foo.prop5?.should eq(1234)
    end
  end

  context "exclaim mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      foo.responds_to?(:prop6?).should be_true
      foo.responds_to?(:prop6).should be_true

      foo.@prop6.should be_nil
      foo.prop6?.should be_nil

      expect_raises NilAssertionError do
        foo.prop6
      end

      typeof(foo.prop6?).should eq(Int32?)
      typeof(foo.prop6).should eq(Int32)
      typeof(foo.@prop6).should eq(Int32?)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.@prop7.should eq(1234)
      foo.prop7.should eq(1234)
      foo.prop7?.should eq(1234)
    end
  end
end
