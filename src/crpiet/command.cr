module Crpiet
  abstract class Command
    @number_of_codels : Int32

    def initialize(@number_of_codels)
    end

    abstract def exec(context : Program)

    def self.from_color_transition(from : ColorGroup, to : ColorGroup) : Command
      raise "Color white doesn't generate any commands" if from.color == COLORS["FFFFFF"] || to.color == COLORS["FFFFFF"]
      raise "Color black doesn't generate any commands" if from.color == COLORS["000000"] || to.color == COLORS["000000"]

      amount = from.codels.size

      hue_diff = (to.color.hue - from.color.hue) % HUE_LEVELS
      light_diff = (to.color.light - from.color.light) % LIGHT_LEVELS

      diff = {hue_diff, light_diff}

      case diff
      when {0, 1} then PushCommand.new(amount)
      when {0, 2} then PopCommand.new(amount)
      when {1, 0} then AddCommand.new(amount)
      when {1, 1} then SubtractCommand.new(amount)
      when {1, 2} then MultiplyCommand.new(amount)
      when {2, 0} then DivideCommand.new(amount)
      when {2, 1} then ModCommand.new(amount)
      when {2, 2} then NotCommand.new(amount)
      when {3, 0} then GreaterCommand.new(amount)
      when {3, 1} then PointerCommand.new(amount)
      when {3, 2} then SwitchCommand.new(amount)
      when {4, 0} then DuplicateCommand.new(amount)
      when {4, 1} then RollCommand.new(amount)
      when {4, 2} then InNumberCommand.new(amount)
      when {5, 0} then InCharCommand.new(amount)
      when {5, 1} then OutNumberCommand.new(amount)
      when {5, 2} then OutCharCommand.new(amount)
      else raise "Invalid color transition"
      end
    end
  end

  class PushCommand < Command
    def exec(context : Program)
      context.stack.push(@number_of_codels)
      nil
    end
  end

  class PopCommand < Command
    def exec(context : Program)
      context.stack.pop?
      nil
    end
  end

  class AddCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b + a)
      nil
    end
  end

  class SubtractCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b - a)
      nil
    end
  end

  class MultiplyCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b * a)
      nil
    end
  end

  class DivideCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      return nil if context.stack.last == 0
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b // a)
      nil
    end
  end

  class ModCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      return nil if context.stack.last == 0
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b % a)
      nil
    end
  end

  class NotCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      a = context.stack.pop
      context.stack.push(0) if a != 0
      context.stack.push(1) if a == 0
      nil
    end
  end

  class GreaterCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(1) if b > a
      context.stack.push(0) if b <= a
      nil
    end
  end

  class PointerCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      a = context.stack.pop
      a.times { context.dp.rotate_cw } if a > 0
      a.abs.times { context.dp.rotate_ccw } if a < 0
      nil
    end
  end

  class SwitchCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      a = context.stack.pop
      a.abs.times { context.cc.switch }
      nil
    end
  end

  class DuplicateCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      context.stack.push(context.stack.last(1).first)
      nil
    end
  end

  class RollCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      d = context.stack.last(2).first
      return nil if d < 0
      return nil if d > context.stack.size - 2
      a = context.stack.pop # Number of rolls
      b = context.stack.pop # Depth
      c = context.stack.pop(b)
      context.stack.concat(c.rotate(-a))
      nil
    end
  end

  class InNumberCommand < Command
    def exec(context : Program)
      if a = context.in.read_line.to_i?
        context.stack.push(a)
      end
      nil
    end
  end

  class InCharCommand < Command
    def exec(context : Program)
      if a = context.in.read_char
        context.stack.push(a.ord)
      end
      nil
    end
  end

  class OutNumberCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      a = context.stack.pop
      context.out << a.to_s
      nil
    end
  end

  class OutCharCommand < Command
    def exec(context : Program)
      return nil if context.stack.empty?
      a = context.stack.pop
      context.out << a.chr
      nil
    end
  end
end
