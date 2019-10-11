require "./spec_helper"

@[Croperty::Property(prop1: Int32)]
@[Croperty::Property(prop2: Int32, init: 1234)]
@[Croperty::Property(prop3: Int32, init: 1234, lazy_init: true)]
@[Croperty::Property(prop4: Int32, mode: Croperty::Mode::Query)]
@[Croperty::Property(prop5: Int32, init: 1234, mode: Croperty::Mode::Query)]
@[Croperty::Property(prop6: Int32, mode: Croperty::Mode::Exclaim)]
@[Croperty::Property(prop7: Int32, init: 1234, mode: Croperty::Mode::Exclaim)]
@[Croperty::Getter(getter1: Int32)]
@[Croperty::Getter(getter2: Int32, init: 1234)]
@[Croperty::Getter(getter3: Int32, init: 1234, lazy_init: true)]
@[Croperty::Getter(getter4: Int32, mode: Croperty::Mode::Query)]
@[Croperty::Getter(getter5: Int32, init: 1234, mode: Croperty::Mode::Query)]
@[Croperty::Getter(getter6: Int32, mode: Croperty::Mode::Exclaim)]
@[Croperty::Getter(getter7: Int32, init: 1234, mode: Croperty::Mode::Exclaim)]
@[Croperty::Setter(setter1: Int32)]
@[Croperty::Setter(setter2: Int32, init: 1234)]
class TestedObject
  include Croperty::Generator(self)
end

describe Croperty do
  describe "property" do
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

  describe "getter" do
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

  describe "setter" do
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
end
