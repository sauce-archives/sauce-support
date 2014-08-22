require 'selenium/webdriver'

module LightSauce
  class << self
    def username
      ENV['SAUCE_USER_NAME']
    end

    def access_key
      ENV['SAUCE_API_KEY']
    end

    def sauce_server
      'ondemand.saucelabs.com'
    end

    def sauce_port
      80
    end

    def authentication
      "#{username}:#{access_key}"
    end

    def sauce_endpoint
      "http://#{authentication}@#{sauce_server}:#{sauce_port}/wd/hub"
    end

    def caps
      {
        'browserName' => ENV['SELENIUM_BROWSER'],
        'version' => ENV['SELENIUM_VERSION'],
        'platform' => ENV['SELENIUM_PLATFORM']
      }
    end
  end

  Capybara.register_driver :light_sauce do |app|
  Capybara::Selenium::Driver.new( app,
                                  :browser => :remote,
                                  :url => sauce_endpoint,
                                  :desired_capabilities => caps)
  end
end

Capybara.default_driver = :light_sauce
Capybara.javascript_driver = :light_sauce