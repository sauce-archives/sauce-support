Running the same test on multiple browsers
------------------------------------------

What this example covers
========================

This example covers a simple setup for a chunk of code using a Remote Selenium WebDriver object, over several different platforms sequentially.

What this example does not cover
================================

This example does not:
  * Do custom metadata
  * Use Sauce Connect
  * Run on multiple platforms in parallel

Pre-requisites
==============

You will need:
 * A Sauce Labs account, your Sauce username and access key
 * A working Ruby 2.0 installation with bundler installed

Running the example
===================

```bash
    $ bundle exec ruby run_multiple_browsers.rb
```

You should see:

```
Started session 27cee518a68a487fb1b31101cdf76457 for {:browserName=>"Chrome", "browser-version"=>"30", "platform"=>"Windows 7"}
Started session bc4950b5dd684510a643062ba86590bd for {:browserName=>"Chrome", "browser-version"=>"31", "platform"=>"Windows 8"}
```

How it works
============

This example is a basic variation on a normal, remote webdriver.  The heart of the example is the `test_with_many_platforms` method.

### test_with_many_platforms
The `test_with_many_platforms` method takes a block.  It fetches the list of capabilities from the `platforms` method and iterates over them.

Each iteration, a new http client is created (See below).  The current iteration's capabilities and the new http client are used to create a Remote WebDriver, targetted at Sauce Labs' service.

The session_id of the WebDriver is captured, as this is the job_id for the job on Sauce Labs' side.

The webdriver is then passed to the block: `block_result = yield driver`.  If the block returns `true` or `nil`, then `result` is set true:

```ruby
   block_result = yield driver
   result = block_result || block_result.nil?
```

Finally, quit is called on the driver

### Finalising the test
At the end of `test_with_many_platforms`, the driver is quit Sauce Labs notified of the job's success or failure via the sauce_whisk gem.

To prevent exceptions from leaving orphaned Sauce sessions, this is done inside an `ensure` block.  If the driver was never created (Say an exception was thrown during creation), this is skipped:

```ruby
    ensure
      unless driver.nil?
        driver.quit
        SauceWhisk::Jobs.change_status job_id, result
      end
    end
```

### The Http Client
By default, Selenium uses the standard Net::HTTP client for its network connections.  With Remote grids, starting sessions can take longer then standard timeout periods, and fall afoul of connection closes.

To get around this, we're using the `net-http-persistent` gem, which uses keep-alives to keep the connection, uh, alive.  We included `net-http-persistant` in our `Gemfile`, and require the Selenium library's wrapper around it:

```ruby
    require 'selenium/webdriver/remote/http/persistent'`
```

Inside `test_with_many_platforms`, we create an instance of the client, and give it a generous 5 minute timeout:

```ruby
    client = Selenium::WebDriver::Remote::Http::Persistent.new
    client.timeout = 300 # seconds
```

Then we pass it to the remote webdrive using the `:client` option.

### platforms
The platforms method is super simple;  It's just an array of desired capabilities taken from the [Sauce Labs Platforms Page](https://saucelabs.com/platforms) and transformed into a hash so that:

```ruby
    caps.version = '30'   #becomes 'version' => '30'
    caps.platform = 'Windows 7'  #becomes 'platform' => 'Windows 7'
    caps = Selenium::WebDriver::Remote::Capabilities.chrome #becomes 'browserName' => Chrome

    {:browserName => 'Chrome', 'browser-version' => '30', 'platform' => 'Windows 7'}
```

### The test itself
In this example, test code is passed as a block to `test_with_many_platforms`.  It's provided a single parameter, the 'driver' object which is the WebDriver object for this test.  The test code then interacts with it normally, once for each browser in the browser array.