require_relative "../lib/rack_n_roll"
require "sauce_helper"
require "server"
require "capybara/rspec"

# Start a server for each test thread
RSpec.configure do |c|
  c.before :suite do
    Server.start
  end
end