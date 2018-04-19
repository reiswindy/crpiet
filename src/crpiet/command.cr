module Crpiet
  abstract class Command
    @number_of_codels : Int32
  
    def initialize(@number_of_codels)
    end
  
    abstract def exec(context : Program)
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
      return nil if last(1).first == 0
      a = context.stack.pop
      b = context.stack.pop
      context.stack.push(b / a)
      nil
    end
  end
  
  class ModCommand < Command
    def exec(context : Program)
      return nil if context.stack.size < 2
      return nil if last(1).first == 0
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
      context.stack.concat(c.rotate(a))
      nil
    end
  end
  
  class InNumberCommand < Command
    def exec(context : Program)
      if a = context.in.gets.to_i?
        context.stack.push(a)
      end
      nil
    end
  end
  
  class InCharCommand < Command
    def exec(context : Program)
      if a = context.in.gets(1)
        context.stack.push(a.byte_at(0))
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
      context.out.write_byte(a)
      nil
    end
  end  
end