require "spec"
require "../src/crpiet"

module SpecHelper
    Files = Dir.children("#{__DIR__}/piet_programs").reduce({} of String => String) do |memo, file|
        memo[file] = "#{__DIR__}/piet_programs/#{file}"
        memo
    end
end