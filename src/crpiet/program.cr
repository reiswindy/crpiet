require "./command"

class Crpiet::DirectionPointer
  DIRECTIONS = [:right, :down, :left, :up]
  @index : Int32 = 0

  def rotate_cw
    @index = (i + 1) % DIRECTIONS.size
    nil
  end

  def rotate_ccw
    @index = (i - 1) % DIRECTIONS.size
    nil
  end

  def direction : Symbol
    DIRECTIONS[@index]
  end
end

class Crpiet::CodelChooser
  DIRECTIONS = [:left, :right]
  @index : Int32 = 0

  def switch
    @index = (i + 1) % DIRECTIONS.size
    nil
  end

  def direction : Symbol
    DIRECTIONS[@index]
  end
end

class Crpiet::Program
  @stack = [] of Int32
  @commands : Array(Command)

  def initialize(@commands = [] of Command, @out : IO = STDOUT, @in : IO = STDIN)
    @cc = CodelChooser.new
    @dp = DirectionPointer.new
  end

  getter :cc, :dp, :stack, :out, :in

  def run
    @commands.each do |cmd|
      cmd.exec(self)
    end
  end
end