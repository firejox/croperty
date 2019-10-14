require "./spec_helper"

@[Croperty::Getter(getter1: Int32)]
@[Croperty::Getter(getter2: Int32, init: 1234)]
@[Croperty::Getter(getter3: Int32, init: 1234, lazy_init: true)]
@[Croperty::Getter(getter4?: Int32)]
@[Croperty::Getter(getter5?: Int32, init: 1234)]
@[Croperty::Getter(getter6!: Int32)]
@[Croperty::Getter(getter7!: Int32, init: 1234)]
class TestedObject
  include Croperty::Generator(self)
end

describe Croperty::Getter do
  it "only has getter method" do
    foo = TestedObject.new

    foo.responds_to?(:getter1).should be_true
    foo.responds_to?(:getter1=).should be_false
  end

  context "default mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      typeof(foo.getter1).should eq(Int32)
      typeof(foo.@getter1).should eq(Int32)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.getter2.should eq(1234)
    end

    it "can be used with lazy initialization" do
      foo = TestedObject.new

      foo.@getter3.should be_nil
      foo.getter3.should eq(1234)
      foo.@getter3.should eq(1234)

      typeof(foo.getter3).should eq(Int32)
      typeof(foo.@getter3).should eq(Int32?)
    end
  end

  context "query mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      foo.responds_to?(:getter4?).should be_true
      foo.responds_to?(:getter4).should be_false

      foo.@getter4.should be_nil
      foo.getter4?.should be_nil

      typeof(foo.getter4?).should eq(Int32?)
      typeof(foo.@getter4).should eq(Int32?)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.@getter5.should eq(1234)
      foo.getter5?.should eq(1234)
    end
  end

  context "exclaim mode" do
    it "can be used without initialization" do
      foo = TestedObject.new

      foo.responds_to?(:getter6?).should be_true
      foo.responds_to?(:getter6).should be_true

      foo.@getter6.should be_nil
      foo.getter6?.should be_nil

      expect_raises NilAssertionError do
        foo.getter6
      end

      typeof(foo.getter6?).should eq(Int32?)
      typeof(foo.getter6).should eq(Int32)
      typeof(foo.@getter6).should eq(Int32?)
    end

    it "can be used with initialization" do
      foo = TestedObject.new

      foo.@getter7.should eq(1234)
      foo.getter7.should eq(1234)
      foo.getter7?.should eq(1234)
    end
  end
end
