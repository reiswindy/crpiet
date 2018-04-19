module Crpiet
  enum Hue
    Red 
    Yellow
    Green
    Cyan
    Blue
    Magenta
    Black
    White
  end

  enum Light
    Light
    Normal
    Dark
  end

  COLORS = {
    "FFC0C0" => Color.new(Hue::Red, Light::Light),
    "FFFFC0" => Color.new(Hue::Yellow, Light::Light),
    "C0FFC0" => Color.new(Hue::Green, Light::Light),
    "C0FFFF" => Color.new(Hue::Cyan, Light::Light),
    "C0C0FF" => Color.new(Hue::Blue, Light::Light),
    "FFC0FF" => Color.new(Hue::Magenta, Light::Light),

    "FF0000" => Color.new(Hue::Red, Light::Normal),
    "FFFF00" => Color.new(Hue::Yellow, Light::Normal),
    "00FF00" => Color.new(Hue::Green, Light::Normal),
    "00FFFF" => Color.new(Hue::Cyan, Light::Normal),
    "0000FF" => Color.new(Hue::Blue, Light::Normal),
    "FF00FF" => Color.new(Hue::Magenta, Light::Normal),

    "C00000" => Color.new(Hue::Red, Light::Dark),
    "C0C000" => Color.new(Hue::Yellow, Light::Dark),
    "00C000" => Color.new(Hue::Green, Light::Dark),
    "00C0C0" => Color.new(Hue::Cyan, Light::Dark),
    "0000C0" => Color.new(Hue::Blue, Light::Dark),
    "C000C0" => Color.new(Hue::Magenta, Light::Dark),

    "FFFFFF" => Color.new(Hue::White, -1),
    "000000" => Color.new(Hue::Black, -1),
  }

  class Color
    @hue : Int32
    @light : Int32

    def initialize(@hue, @light)
    end

    getter :hue, :light

    def ==(other : self)
      @hue == other.hue && @light == other.light
    end
  end

  class Codel
    @color_group : ColorGroup
    @position : Tuple(Int32, Int32)

    def initialize(@color_group, @position)
    end

    getter :color_group, :position
  end

  class ColorGroup
    @color : Color
    @codels = [] of Codel
    @edges = {
      :right => {} of Symbol => Codel,
      :down => {} of Symbol => Codel,
      :left => {} of Symbol => Codel,
      :up => {} of Symbol => Codel,
    }

    def initialize(@color)
    end

    getter :color, :codels, :edges

    def calculate_edges
      max = {} of Symbol => Int32

      @codels.each do |codel|
        x, y = codel.position
        max[:right] = x if !max.has_key?(:right)
        max[:down] = y if !max.has_key?(:down)
        max[:left] = x if !max.has_key?(:left)
        max[:up] = y if !max.has_key?(:up)

        max[:right] = x if max[:right] < x
        max[:down] = y if max[:down] < y
        max[:left] = x if max[:left] > x
        max[:up] = y if max[:up] > x
      end

      @codels.each do |codel|
        x, y = codel.position
        @edges[:right][:left]  = codel if !@edges[:right].has_key?(:left)
        @edges[:right][:right] = codel if !@edges[:right].has_key?(:right)
        @edges[:down][:left]   = codel if !@edges[:down].has_key?(:left)
        @edges[:down][:right]  = codel if !@edges[:down].has_key?(:right)
        @edges[:left][:left]   = codel if !@edges[:left].has_key?(:left)
        @edges[:left][:right]  = codel if !@edges[:left].has_key?(:right)
        @edges[:up][:left]     = codel if !@edges[:up].has_key?(:left)
        @edges[:up][:right]    = codel if !@edges[:up].has_key?(:right)

        @edges[:right][:left]  = codel if @edges[:right][:left].position[1] < y
        @edges[:right][:right] = codel if @edges[:right][:right].position[1] > y
        @edges[:down][:left]   = codel if @edges[:down][:left].position[0] < x
        @edges[:down][:right]  = codel if @edges[:down][:right].position[0] > x
        @edges[:left][:left]   = codel if @edges[:left][:left].position[1] > y
        @edges[:left][:right]  = codel if @edges[:left][:right].position[1] < y
        @edges[:up][:left]     = codel if @edges[:up][:left].position[0] > x
        @edges[:up][:right]    = codel if @edges[:up][:right].position[0] < x
      end
    end
  end
end