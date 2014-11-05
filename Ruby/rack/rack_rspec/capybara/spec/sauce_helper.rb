require "sauce"
require "sauce/capybara"
require_relative "../lib/rack_n_roll"

Sauce.config do |c|
  c[:browsers] = [
    ["Windows 7", "Chrome", "30"],
    ["Windows 8", "Firefox", "28"],
    ["OSX 10.8", "Safari", "6"],
    ["Linux", "Chrome", "26"]
  ]
  c[:start_local_application] = false
end

Capybara.default_driver = :sauce
Capybara.javascript_driver = :sauce

Capybara.app = RackNRoll.new