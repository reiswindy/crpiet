require "./spec_helper"

describe Crpiet do
  # TODO: Write tests

  it "works" do
    false.should eq(true)
  end

  context "" do
    
  end

  context "using three_plus_five.png" do
    file = SpecHelper::Files["three_plus_five.png"]

    it "prints 6" do
      Crpiet::Parser.new(file)
    end
  end

  context "using hello_world.png" do
    file = SpecHelper::Files["hello_world.png"]

    it "prints Hello World!" do
      Crpiet::Parser.new(file)
    end
  end
end
