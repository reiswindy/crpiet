require "./spec_helper"

describe Crpiet do

  context "using three_plus_five.png" do
    file = SpecHelper::Files["three_plus_five.png"]

    it "has the correct colors on the codel map" do
      parser = Crpiet::Parser.new(file)
      parser.parse
      parser.codel_map[{0, 0}].color_group.color.should eq(Crpiet::COLORS["FF0000"])
      parser.codel_map[{4, 1}].color_group.color.should eq(Crpiet::COLORS["000000"])
      parser.codel_map[{5, 2}].color_group.color.should eq(Crpiet::COLORS["FFFFFF"])
      parser.codel_map[{5, 0}].color_group.color.should eq(Crpiet::COLORS["FFFFC0"])
    end

    it "has the correct edge in the codel group" do
      parser = Crpiet::Parser.new(file)
      parser.parse
      color_group_edges = parser.codel_map[{0, 0}].color_group.edges

      color_group_edges[:r][:l].position.should eq({0, 0})
      color_group_edges[:r][:r].position.should eq({0, 2})
      color_group_edges[:d][:l].position.should eq({0, 2})
      color_group_edges[:d][:r].position.should eq({0, 2})
      color_group_edges[:l][:l].position.should eq({0, 2})
      color_group_edges[:l][:r].position.should eq({0, 0})
      color_group_edges[:u][:l].position.should eq({0, 0})
      color_group_edges[:u][:r].position.should eq({0, 0})
    end

    it "prints 8" do
      result = String::Builder.build do |io|
        Crpiet.run(file, io)
      end
      result.should eq("8")
    end
  end

  context "using hello_world.png" do
    file = SpecHelper::Files["hello_world.png"]

    it "prints Hello world!" do
      result = String::Builder.build do |io|
        Crpiet.run(file, io)
      end
      result.should eq("Hello world!")
    end
  end

  context "using piet.png" do
    file = SpecHelper::Files["piet.png"]

    it "prints Piet" do
      result = String::Builder.build do |io|
        Crpiet.run(file, io)
      end
      result.should eq("Piet")
    end
  end
end
