require "./crpiet"

def usage
  "Usage: crpiet FILE"
end

filename = ARGV[0]?
if filename && File.exists?(filename)
  begin
    Crpiet.run(filename)
  rescue exception
    puts "An error occurred during execution"
  end
else
  puts usage
end
