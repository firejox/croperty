require "./spec_helper"

@[Croperty::Property(x: Int32, init: 1)]
class Foo
  include Croperty::Generator(self)
end

describe Croperty do
  it "works" do
    foo = Foo.new
    foo.x.should eq(1)
  end
end
