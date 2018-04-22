require "./crpiet/*"

# TODO: Write documentation for `Crpiet`
module Crpiet
  def self.run(filename : String, io_out : IO = STDOUT, io_in : IO = STDIN)
    parser = Parser.new(filename)
    parser.parse
    app = Program.new(parser, io_out, io_in)
    app.run
  end
end
