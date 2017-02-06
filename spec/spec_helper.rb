$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "clutch"
require "pp"

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
