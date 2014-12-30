require_relative "simple_sauce_setup"

Capybara.register_driver :light_sauce do |app|
  Capybara::Selenium::Driver.new( app,
                                  SimpleSauce.webdriver_config )
end

Capybara.default_driver = :light_sauce
Capybara.javascript_driver = :light_sauce