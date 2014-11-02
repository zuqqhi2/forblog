require "rubygems"
require 'rspec'
Dir[File.join(File.dirname(__FILE__), "..", "src/lib", "/**/*.rb")].each{|f| require f }

include Atnd

RSpec.configure do
end
