require "./spec_helper"

dummy_file = SpecHelper::Files["three_plus_five.png"]
dummy_parser = Crpiet::Parser.new(dummy_file)
app = Crpiet::Program.new(dummy_parser, STDOUT, STDIN)

describe Crpiet::PushCommand do
  it "executes push command correctly" do
    app.stack.clear

    cmd = Crpiet::PushCommand.new(10)
    cmd.exec(app)

    app.stack.should eq([10])
  end
end

describe Crpiet::PopCommand do
  it "executes pop command correctly" do
    app.stack.clear
    app.stack.push(1)

    cmd = Crpiet::PopCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([] of Int32)
  end
end

describe Crpiet::AddCommand do
  it "executes add command correctly" do
    app.stack.clear
    app.stack.push(1, 2)

    cmd = Crpiet::AddCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([3])
  end
end

describe Crpiet::SubtractCommand do
  it "executes subtract command correctly" do
    app.stack.clear
    app.stack.push(2, 1)

    cmd = Crpiet::SubtractCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([1])
  end
end

describe Crpiet::MultiplyCommand do
  it "executes multiply command correctly" do
    app.stack.clear
    app.stack.push(2, 1)

    cmd = Crpiet::MultiplyCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([2])
  end
end

describe Crpiet::DivideCommand do
  it "executes divide command correctly" do
    app.stack.clear
    app.stack.push(6, 2)

    cmd = Crpiet::DivideCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([3])
  end
end

describe Crpiet::ModCommand do
  it "executes mod command correctly" do
    app.stack.clear
    app.stack.push(6, 4)

    cmd = Crpiet::ModCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([2])
  end
end

describe Crpiet::NotCommand do
  it "executes not command correctly" do
    app.stack.clear
    app.stack.push(0)

    cmd = Crpiet::NotCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([1])
  end
end

describe Crpiet::GreaterCommand do
  it "executes greater command correctly" do
    app.stack.clear
    app.stack.push(20, 10)

    cmd = Crpiet::GreaterCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([1])
  end
end

describe Crpiet::GreaterCommand do
  it "executes greater command correctly" do
    app.stack.clear
    app.stack.push(20, 10)

    cmd = Crpiet::GreaterCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([1])
  end
end

describe Crpiet::PointerCommand do
  it "executes pointer command correctly" do
    app.stack.clear
    app.stack.push(2)

    cmd = Crpiet::PointerCommand.new(1)
    cmd.exec(app)

    app.dp.direction.should eq(:l)
  end
end

describe Crpiet::SwitchCommand do
  it "executes switch command correctly" do
    app.stack.clear
    app.stack.push(1)

    cmd = Crpiet::SwitchCommand.new(1)
    cmd.exec(app)

    app.cc.direction.should eq(:r)
  end
end

describe Crpiet::DuplicateCommand do
  it "executes duplicate command correctly" do
    app.stack.clear
    app.stack.push(1)

    cmd = Crpiet::DuplicateCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([1, 1])
  end
end

describe Crpiet::RollCommand do
  it "executes roll command correctly" do
    app.stack.clear
    app.stack.push(99, 98, 98, 98, 1, 5, 3, 1, 6, 4)

    cmd = Crpiet::RollCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([99, 98, 1, 5, 3, 1, 98, 98])
  end
end

describe Crpiet::InNumberCommand do
  it "executes in (number) command correctly" do
    io_in = IO::Memory.new("99")
    app = Crpiet::Program.new(dummy_parser, STDOUT, io_in)
    app.stack.clear

    cmd = Crpiet::InNumberCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([99])
  end
end

describe Crpiet::InCharCommand do
  it "executes in (char) command correctly" do
    io_in = IO::Memory.new("a")
    app = Crpiet::Program.new(dummy_parser, STDOUT, io_in)
    app.stack.clear

    cmd = Crpiet::InCharCommand.new(1)
    cmd.exec(app)

    app.stack.should eq([97])
  end
end

describe Crpiet::OutNumberCommand do
  it "executes out (number) command correctly" do
    text = String.build do |io_out|
      app = Crpiet::Program.new(dummy_parser, io_out, STDIN)
      app.stack.clear
      app.stack.push(97)

      cmd = Crpiet::OutNumberCommand.new(1)
      cmd.exec(app)
    end

    text.should eq("97")
  end
end

describe Crpiet::OutCharCommand do
  it "executes out (char) command correctly" do
    text = String.build do |io_out|
      app = Crpiet::Program.new(dummy_parser, io_out, STDIN)
      app.stack.clear
      app.stack.push(97)

      cmd = Crpiet::OutCharCommand.new(1)
      cmd.exec(app)
    end

    text.should eq("a")
  end
end
