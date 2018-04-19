require "stumpy_png"

class Crpiet::Parser
  @image_canvas : StumpyCore::Canvas

  def initialize(filename : String)
    @image_canvas = StumpyPNG.read(filename)
  end

  def parse
    processed_pixels = {} of Tuple(Int32, Int32) => StumpyCore::RGBA
    h = @image_canvas.height
    w = @image_canvas.width
    h.times do |i|
      w.times do |j|
        position = {j, i}
        if processed_pixels.has_key(position)
          next
        end
        color_group = parse_color_group(position)
      end
    end


  end

  private def parse_color_group(initial_position : Tuple(Int32, Int32))
    processed_pixels = {} of Tuple(Int32, Int32) => StumpyCore::RGBA
    adjacent_pixels = [initial_position]
    while position = adjacent_pixels.pop?
      next if processed_pixels.has_key?(position)

      x, y = position
      pixel = @image_canvas[x, y]
      hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
      color = COLORS[hex]? || COLORS["FFFFFF"]

      if up_pixel = @image_canvas.safe_get(x, y - 1)
        up_hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
        up_color = COLORS[hex]? || COLORS["FFFFFF"]
        adjacent_pixels << {x, y - 1} if color == up_color
      end

      if right_pixel = @image_canvas.safe_get(x + 1, y)
        right_hex = rgb_to_hex(right_pixel.r, right_pixel.g, right_pixel.b)
        right_color = COLORS[hex]? || COLORS["FFFFFF"]
        adjacent_pixels << {x + 1, y} if color == right_color
      end

      if down_pixel = @image_canvas.safe_get(x, y + 1)
        down_hex = rgb_to_hex(down_pixel.r, down_pixel.g, down_pixel.b)
        down_color = COLORS[hex]? || COLORS["FFFFFF"]
        adjacent_pixels << {x, y + 1} if color == down_color
      end
      
      if left_pixel = @image_canvas.safe_get(x - 1, y)
        left_hex = rgb_to_hex(left_pixel.r, left_pixel.g, left_pixel.b)
        left_color = COLORS[hex]? || COLORS["FFFFFF"]
        adjacent_pixels << {x - 1, y} if color == left_color
      end
      processed_pixels[position] = pixel
    end
    processed_pixels
  end

  private def rgb_to_hex(r, g, b)
    "#{r.to_s(16, true)}#{g.to_s(16, true)}#{b.to_s(16, true)}"
  end
end


#Define color groups
#Start execution