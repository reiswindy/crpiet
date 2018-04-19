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
        pixel = @image_canvas[j, i]
        hex = rgb_to_hex(pixel.r, pixel.g, pixel.b)
      end
    end


  end

  private def parse_color_groups
    
  end

  private def rgb_to_hex(r, g, b)
    "#{r.to_s(16, true)}#{g.to_s(16, true)}#{b.to_s(16, true)}"
  end
end


#Define color groups
#Start execution