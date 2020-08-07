module Crpiet
  HUE_LEVELS = 6
  LIGHT_LEVELS = 3

  module Hue
    Red = 0
    Yellow = 1
    Green = 2
    Cyan = 3
    Blue = 4
    Magenta = 5
    Black = -1
    White = -2
  end

  module Light
    Light = 0
    Normal = 1
    Dark = 2
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
    getter hue : Int32
    getter light : Int32

    def initialize(@hue, @light)
    end
  end

  class Codel
    getter color_group : ColorGroup
    getter position : Tuple(Int32, Int32)

    def initialize(@color_group, @position)
    end
  end

  class ColorGroup
    @color : Color
    @codels = [] of Codel
    @edges = {
      :r => {} of Symbol => Codel,
      :d => {} of Symbol => Codel,
      :l => {} of Symbol => Codel,
      :u => {} of Symbol => Codel,
    }

    def initialize(@color)
    end

    getter :color, :codels, :edges

    def calculate_edges
      max = {} of Symbol => Int32

      @codels.each do |codel|
        x, y = codel.position
        max[:r] = x if !max.has_key?(:r)
        max[:d] = y if !max.has_key?(:d)
        max[:l] = x if !max.has_key?(:l)
        max[:u] = y if !max.has_key?(:u)

        max[:r] = x if max[:r] < x
        max[:d] = y if max[:d] < y
        max[:l] = x if max[:l] > x
        max[:u] = y if max[:u] > y
      end

      @codels.each do |codel|
        x, y = codel.position

        if x == max[:r]
          @edges[:r][:l]  = codel if !@edges[:r].has_key?(:l)
          @edges[:r][:r] = codel if !@edges[:r].has_key?(:r)

          @edges[:r][:l]  = codel if @edges[:r][:l].position[1] > y
          @edges[:r][:r] = codel if @edges[:r][:r].position[1] < y
        end

        if y == max[:d]
          @edges[:d][:l]   = codel if !@edges[:d].has_key?(:l)
          @edges[:d][:r]  = codel if !@edges[:d].has_key?(:r)

          @edges[:d][:l]   = codel if @edges[:d][:l].position[0] < x
          @edges[:d][:r]  = codel if @edges[:d][:r].position[0] > x
        end

        if x == max[:l]
          @edges[:l][:l]   = codel if !@edges[:l].has_key?(:l)
          @edges[:l][:r]  = codel if !@edges[:l].has_key?(:r)

          @edges[:l][:l]   = codel if @edges[:l][:l].position[1] < y
          @edges[:l][:r]  = codel if @edges[:l][:r].position[1] > y
        end

        if y == max[:u]
          @edges[:u][:l]     = codel if !@edges[:u].has_key?(:l)
          @edges[:u][:r]    = codel if !@edges[:u].has_key?(:r)

          @edges[:u][:l]     = codel if @edges[:u][:l].position[0] > x
          @edges[:u][:r]    = codel if @edges[:u][:r].position[0] < x
        end
      end
    end
  end
end
