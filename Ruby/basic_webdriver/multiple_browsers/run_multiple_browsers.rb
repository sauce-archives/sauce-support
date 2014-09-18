require "selenium-webdriver"
require 'selenium/webdriver/remote/http/persistent'
require "sauce_whisk"

def username
  ENV["SAUCE_USERNAME"]
end

def access_key
  ENV["SAUCE_ACCESS_KEY"]
end

def sauce_endpoint
  'ondemand.saucelabs.com:80/wd/hub'
end

def server_url
  "http://#{username}:#{access_key}@#{sauce_endpoint}"
end

def platforms
  [
    {:browserName => 'Chrome', 'browser-version' => '30', 'platform' => 'Windows 7'},
    {:browserName => 'Chrome', 'browser-version' => '31', 'platform' => 'Windows 8'}
  ]
end

def test_with_many_platforms
  platforms.each do |platform|
    begin
      # Give browsers ample time to start up
      client = Selenium::WebDriver::Remote::Http::Persistent.new
      client.timeout = 300 # seconds
      
      driver = Selenium::WebDriver.for  :remote, 
                                        :url => server_url, 
                                        :http_client => client,
                                        :desired_capabilities => platform

      job_id = driver.session_id

      STDOUT.puts "Started session #{job_id} for #{platform}"
      
      # If the block returns nil, that's a success!
      block_result = yield driver
      result = block_result || block_result.nil?  

    rescue => e
      STDERR.puts e                            
    ensure
      unless driver.nil?
        driver.quit
        SauceWhisk::Jobs.change_status job_id, result
      end
    end
  end      
end

test_with_many_platforms do |d|
  d.navigate.to "http://www.google.com"
end  