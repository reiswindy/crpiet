require "./command"
require "./colors"

class Crpiet::DirectionPointer
  @directions = [:r, :d, :l, :u]

  def rotate_cw
    @directions.rotate!(1)
    nil
  end

  def rotate_ccw
    @directions.rotate!(-1)
    nil
  end

  def direction : Symbol
    @directions.first
  end
end

class Crpiet::CodelChooser
  @directions = [:l, :r]

  def switch
    @directions.rotate!(1)
    nil
  end

  def direction : Symbol
    @directions.first
  end
end

class Crpiet::Program
  @stack = [] of Int32
  @command_history = [] of Command

  def initialize(@parser : Parser, @out : IO = STDOUT, @in : IO = STDIN)
    @cc = CodelChooser.new
    @dp = DirectionPointer.new
  end

  getter :cc, :dp, :stack, :out, :in, :command_history

  def run
    initial_pos = {0, 0}
    codel = @parser.codel_map[initial_pos]

    if codel.color_group.color == COLORS["000000"]
      # TODO: Message? Raise exception?
      return nil
    end

    while true
      next_codel = nil.as(Codel?)

      if codel.color_group.color == COLORS["FFFFFF"]
        trace_codels = {
          :r => [] of Codel,
          :d => [] of Codel,
          :l => [] of Codel,
          :u => [] of Codel,
        }
        while next_codel.nil?
          if trace_codels[@dp.direction].includes?(codel)
            return nil
          end
          traversed_codels = slide(codel.position)
          trace_codels[@dp.direction] = trace_codels[@dp.direction] + traversed_codels

          edge = traversed_codels.last
          next_codel = @parser.codel_map[traverse(edge.position)]?
          if next_codel.nil? || next_codel.color_group.color == COLORS["000000"]
            next_codel = nil
            codel = edge
            @dp.rotate_cw
          end
        end
      else
        retries = 0
        while next_codel.nil?
          edge = codel.color_group.edges[@dp.direction][@cc.direction]
          next_codel = @parser.codel_map[traverse(edge.position)]?

          if next_codel.nil? || next_codel.color_group.color == COLORS["000000"]
            retries = retries + 1
            next_codel = nil
            @cc.switch if retries % 2 == 1
            @dp.rotate_cw if retries % 2 == 0

            if retries == 8
              return nil
            end
          end
        end
        if next_codel.color_group.color != COLORS["FFFFFF"]
          cmd = Command.from_color_transition(codel.color_group, next_codel.color_group)
          @command_history << cmd
          @command_history.last.exec(self)
        end
      end
      codel = next_codel.not_nil!
    end
  end

  private def traverse(initial_pos : Tuple(Int32, Int32))
    x, y = initial_pos
    case direction = @dp.direction
    when :r
      {x + 1, y}
    when :d
      {x, y + 1}
    when :l
      {x - 1, y}
    when :u
      {x, y - 1}
    else
      raise "Invalid direction"
    end
  end

  private def slide(position : Tuple(Int32, Int32))
    raise "Can only slide on white color groups" if @parser.codel_map[position].color_group.color != COLORS["FFFFFF"]

    color_group = @parser.codel_map[position].color_group
    traversed_codels = [] of Codel

    while codel = @parser.codel_map[position]?
      break if codel.color_group != color_group

      traversed_codels << codel
      x, y = codel.position
      case direction = @dp.direction
      when :r
        position = {x + 1, y}
      when :l
        position = {x - 1, y}
      when :d
        position = {x, y + 1}
      when :u
        position = {x, y - 1}
      else
        raise "Invalid direction"
      end
    end
    traversed_codels
  end
end
