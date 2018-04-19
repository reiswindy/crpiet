require "stumpy_png"
require "./colors"

class Crpiet::Parser
  @image_canvas : StumpyCore::Canvas
  @codel_map : Hash(Tuple(Int32, Int32), Codel)

  def initialize(filename : String)
    @image_canvas = StumpyPNG.read(filename)
    @codel_map = {} of Tuple(Int32, Int32) => Codel
  end

  def parse
    h = @image_canvas.height
    w = @image_canvas.width
    h.times do |i|
      w.times do |j|
        position = {j, i}
        if @codel_map.has_key?(position)
          next
        end
        color_group = parse_color_group(position)
        color_group.codels.each do |codel|
          @codel_map[codel.position] = codel
        end
      end
    end
  end

  private def parse_color_group(initial_position : Tuple(Int32, Int32))
    x, y = initial_position
    pixel = @image_canvas[x, y]
    hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
    hex = "FFFFFF" if COLORS.has_key?(hex)

    color_group = ColorGroup.new(COLORS[hex])

    processed_pixels = [] of Tuple(Int32, Int32)
    adjacent_pixels = [initial_position]
    
    while position = adjacent_pixels.pop?
      next if processed_pixels.includes?(position)

      x, y = position
      pixel = @image_canvas[x, y]
      hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
      hex = "FFFFFF" if COLORS.has_key?(hex)
      color_group.codels << Codel.new(color_group, position)

      if up_pixel = @image_canvas.safe_get(x, y - 1)
        up_hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
        up_hex = "FFFFFF" if COLORS.has_key?(up_hex)
        adjacent_pixels << {x, y - 1} if hex == up_hex
      end

      if right_pixel = @image_canvas.safe_get(x + 1, y)
        right_hex = rgb_to_hex(right_pixel.r, right_pixel.g, right_pixel.b)
        right_hex = "FFFFFF" if COLORS.has_key?(right_hexhex)
        adjacent_pixels << {x + 1, y} if hex == right_hex
      end

      if down_pixel = @image_canvas.safe_get(x, y + 1)
        down_hex = rgb_to_hex(down_pixel.r, down_pixel.g, down_pixel.b)
        down_hex = "FFFFFF" if COLORS.has_key?(down_hex)
        adjacent_pixels << {x, y + 1} if hex == down_hex
      end

      if left_pixel = @image_canvas.safe_get(x - 1, y)
        left_hex = rgb_to_hex(left_pixel.r, left_pixel.g, left_pixel.b)
        left_hex = "FFFFFF" if COLORS.has_key?(left_hex)
        adjacent_pixels << {x - 1, y} if hex == left_hex
      end
      processed_pixels << position
    end
    color_group
  end

  private def rgb_to_hex(r, g, b)
    "#{r.to_s(16, true)}#{g.to_s(16, true)}#{b.to_s(16, true)}"
  end
end


#Define color groups
#Start execution