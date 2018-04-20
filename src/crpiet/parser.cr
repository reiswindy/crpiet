require "stumpy_png"
require "./colors"

class Crpiet::Parser
  @image_canvas : StumpyCore::Canvas
  @codel_map : Hash(Tuple(Int32, Int32), Codel)

  def initialize(filename : String)
    @image_canvas = StumpyPNG.read(filename)
    @codel_map = {} of Tuple(Int32, Int32) => Codel
  end

  getter :image_canvas, :codel_map

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
    hex = rgb_to_hex(pixel.to_rgb8)
    hex = "FFFFFF" if !COLORS.has_key?(hex)

    color_group = ColorGroup.new(COLORS[hex])

    processed_pixels = [] of Tuple(Int32, Int32)
    adjacent_pixels = [initial_position]
    
    while position = adjacent_pixels.shift?
      next if processed_pixels.includes?(position)

      x, y = position
      pixel = @image_canvas[x, y]
      hex = rgb_to_hex(pixel.to_rgb8)
      hex = "FFFFFF" if !COLORS.has_key?(hex)
      color_group.codels << Codel.new(color_group, position)

      if up_pixel = @image_canvas.safe_get(x, y - 1)
        up_hex = rgb_to_hex(up_pixel.to_rgb8)
        up_hex = "FFFFFF" if !COLORS.has_key?(up_hex)
        adjacent_pixels << {x, y - 1} if hex == up_hex
      end

      if right_pixel = @image_canvas.safe_get(x + 1, y)
        right_hex = rgb_to_hex(right_pixel.to_rgb8)
        right_hex = "FFFFFF" if !COLORS.has_key?(right_hex)
        adjacent_pixels << {x + 1, y} if hex == right_hex
      end

      if down_pixel = @image_canvas.safe_get(x, y + 1)
        down_hex = rgb_to_hex(down_pixel.to_rgb8)
        down_hex = "FFFFFF" if !COLORS.has_key?(down_hex)
        adjacent_pixels << {x, y + 1} if hex == down_hex
      end

      if left_pixel = @image_canvas.safe_get(x - 1, y)
        left_hex = rgb_to_hex(left_pixel.to_rgb8)
        left_hex = "FFFFFF" if !COLORS.has_key?(left_hex)
        adjacent_pixels << {x - 1, y} if hex == left_hex
      end
      processed_pixels << position
    end
    color_group.calculate_edges
    color_group
  end

  private def rgb_to_hex(rgb : Tuple(UInt8, UInt8, UInt8))
    r, g, b = rgb
    "#{r.to_s(16, true).rjust(2, '0')}#{g.to_s(16, true).rjust(2, '0')}#{b.to_s(16, true).rjust(2, '0')}"
  end
end


#Define color groups
#Start execution