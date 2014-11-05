Sauce with a Rack Application, using RSpec.
-------------------------------------------

Here, you'll find an example of integrating the Sauce gem into a vanilla Rack app.  You don't need any of that fancy ActionWhatzit to have Saucy tests!

The Examples
============
Check out the 'selenium_only' directory to see how to set up your Rack application to run Rspec tests against Sauce Labs, using raw WebDriver objects.  This includes an example of managing your server's lifecycle.

If you want to use Capybara instead, it can help manage your server lifecycle instead.  Check out the 'capybara' directory.

The Basics of Getting your Rack Application Sauced
==================================================

1. Pick a platform.
2. Point a Remote WebDriver at the Sauce endpoint.
3. Manage your Rack application's lifecycle, using one of the [Sauce Connect Ports](https://docs.saucelabs.com/reference/sauce-connect/#can-i-access-applications-on-localhost-)
4. Make sure you call 'quit' when you're finished.
5. Use our [REST API](https://docs.saucelabs.com/reference/rest-api/) to inform Sauce Labs whether your tests passed or failed.

Sauce Labs functions as a [Selenium Grid](https://code.google.com/p/selenium/wiki/Grid2).  Everything Grid can do, Sauce can do (sometimes better!).  Just point at Sauce Labs' Grid endpoint, ask for a valid platform and you're testing with Sauce Labs.

### A Valid Platform
Our [Platforms Page](http://www.saucelabs.com/platforms) shows the available platforms you can use.  Click on the OS, then the browser you're after, and make sure you've selected 'Ruby' from the language dropdown.  Then copy and paste:

```ruby
  caps = Selenium::WebDriver::Remote::Capabilities.chrome
  caps.platform = 'Windows 8'
  caps.version = '36'
```

### Create a Remote WebDriver

You'll need your Sauce username and Sauce access key as HTTP authentication credentials.

```ruby
  require "selenium/webdriver"

  auth = "#{sauce_username}:#{sauce_access_key}"
  
  // The Endpoint URL
  sauce_endpoint = "ondemand.saucelabs.com:80/wd/hub"
  
  server = "http://#{auth}@#{sauce_endpoint}"
  driver = Selenium::WebDriver.for :remote, :url => server
                                            :desired_capabilities => caps
```
That's it.  Interact with `driver` as you would [any other WebDriver object](https://code.google.com/p/selenium/wiki/RubyBindings)

### Managing your application's lifecycle
When using a Rails application, the Sauce gem is able to manage starting and stopping server instances for you.  With a Rack application on localhost, there's a little more work.

Because Sauce Labs VMs run real browsers, they need to contact a real server (not rack-test).  Rack has many servers which support it, but they won't always be running on one of the ports supported by [Sauce Connect, our secure testing proxy](https://docs.saucelabs.com/reference/sauce-connect/#can-i-access-applications-on-localhost-).

Furthermore, you may want to start separate instances for parallel test runs, if you want to keep your app instances totally separate and take advantage of extra cores your machine has.

### Calling it quits
You always want to close your Sauce session when you're done.  Sauce will time out inactive sessions after 90 seconds, by why waste your Sauce Labs time (and end up with sessions all marked 'error')?

Calling `quit` on the WebDriver object will close off your Sauce Labs session.  Wrapping this in an 'ensure' block will stop exceptions (like test failures) from skipping this step:

```ruby
  begin
    driver = Selenium::WebDriver.for :remote, :url => server
                                              :desired_capabilities => caps
  ensure
    driver.quit unless driver.nil?
  end
```

### The REST API
Selenium went to college and did a really specialized degree in controlling browsers.  It doesn't know anything else;  It's not sure whether a test passes or fails, and doesn't even know what a test failure *is*.

So, Sauce Labs have added a [REST API](https://docs.saucelabs.com/reference/rest-api/) to let you mark tests as Passed or Failed from the only thing that knows if they have:  Your test framework.

We've also written a gem called [Sauce Whisk](https://github.com/saucelabs/sauce_whisk) which gives you a Rubyish way to interact with our rest API.

```ruby
  require "sauce_whisk"
  // Get the Job ID from the WebDriver object
  job_id = driver.session_id

  // Status is 'true' for passed, 'false' for failed
  SauceWhisk::Jobs.change_status job_id, status
```