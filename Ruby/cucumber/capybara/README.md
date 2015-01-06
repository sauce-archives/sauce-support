Cucumber and Capybara
---------------------------------

What this example covers
========================

This example covers a simple setup for running Cucumber tests with Capybara, using Sauce Labs as the browsers behind Capybara.

It assumes a basic familiarity with how Cucumber and Capybara operate.

What this example does not cover
================================

This example does not:
  * Do build or tag metadata
  * Name tests based on Scenario names
  * Use or manage Sauce Connect
  * Run on multiple platforms automatically
  * Report results of tests to Sauce Labs

Pre-requisites
==============

You will need:

1. a working Ruby environment
2. [Bundler](http://bundler.io/) installed
3. A free [Sauce Labs](http://www.saucelabs.com) account
4. Your Sauce Labs username and access key stored in the `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY` environment variables, respectively

Running the example
===================

```bash
    $ bundle update
    $ bundle exec cucumber --format pretty
```

You should see something like:

```
Feature: Navigating somewhere else

  @selenium
  Scenario: Going to fhdgest.com               # features/failed_selenium.feature:4
    Given I have opened http://fhdgest.com     # features/step_definitions/navigation_steps.rb:1
    Then I should not see a box called 'query' # features/step_definitions/navigation_steps.rb:10

Feature: Navigating somewhere

  @selenium
  Scenario: Going to rubygems.org               # features/simple_selenium.feature:4
    Given I have opened http://www.rubygems.org # features/step_definitions/navigation_steps.rb:1
    Then I should see a box called 'query'      # features/step_definitions/navigation_steps.rb:5

2 scenarios (2 passed)
4 steps (4 passed)
0m36.852s
```

How it works & Adapting to your features
========================================

Ultimately, Sauce Labs operates like a standard Remote Selenium server.  As long as you target our Selenium endpoint with a Remote WebDriver object, you'll get a session started on Sauce.

For this example, there are three main files dealing with the three things we need to do to run a Cucumber test, with Capybara, on Sauce:

1. We need to configure a Sauce session
2. We need create a Capybara driver that will use the Sauce configuration
3. We need Cucumber to use the Capybara session and close it off when it's done.

This example separates each of these responsibilities into separate files.

### Creating a Sauce Session
We create our driver configuration class in `/features/support/simple_sauce_setup.rb`.  This class is reponsible for giving a valid Selenium configuration for the platform we request.

We'll use this class by calling the `desired_capabilities=` method to pass in our [platform](https://saucelabs.com/platforms) configuration, and calling `webdriver_config` to get a set of parameters suitable for passing to Selenium to create a session.

We're following good practice and wrapping different chunks of information in methods.  From line 7 to line 29, we're reading in the authentication details (from environment variables) & configuring the address of Sauce's Selenium server.

On line 5, we create an attr_writer for `desired_capabilites`.  On line 55, we create the equivalent reader function, where we determine our desired capabilites based on what the user has configured:
1.  If the environment variables 'SAUCE_BROWSER', `SAUCE_PLATFORM` and `SAUCE_VERSION` are all set, use them.
2.  Otherwise, if a value was passed into `SimpleSauce.desired_capabilities=`, use that.
3.  Finally, if neither of those are present, use the defaults defined in `default_capabilities`.

On line 59, we define `webdriver_config`.  This method returns all three of the parameters needed to configure Selenium to run on Sauce Labs
1.  Use a `:remote` browser
2.  Use the Sauce Labs endpoint as the remote Selenium server
3.  The platform to request from Sauce Labs

### Creating a Capybara driver, using the Sauce configuration
Capybara includes a Selenium driver out of the box, and it isn't hard to configure it to better suit our needs.  We do this in `/features/support/sauce_capybara_driver.rb`.

On line 3, we register a new driver, called `:light_sauce`.  On line 4, we create a standard Capybara Selenium driver, but we pass in the parameters returned by `SimpleSauce.webdriver_config`.

On line 8 & 9, we're making the `light_sauce` driver the default for both Javascript and non-Javascript Capybara tests.

### Making Cucumber use (and close) the Capybara session
The `features/support/env.rb` file is responsible for creating & destroying Capybara sessions, as well as passing platform configuration into the SimpleSauce object.  
The `Around` block on line 5 manages starting and stopping Sauce sessions.  Capybara will automatically start a new session when one isn't available.  By default, it will leave this session open until Cucumber exists.  This isn't good for testing with Sauce Labs, as all your tests will run in the same Sauce Labs job.

We get around this using the `Around` block.  On line 6, we call the block that's been passed into the Around block, effectively allowing the test to continue.  On line 7, we get the Selenium WebDriver object that Capybara is using (`::Capybara.current_session.driver`) and call `quit()`, thus closing off the Sauce session.

This means that, the next time Capybara tries to take an action (like opening a webpage during another scenario) it will automagically start a new Sauce Labs session first.

On line 10 to 15, we're creating a `DesiredCapabilities` object with the Selenium library, setting its name and passing it to the SimpleSauce class.  This platform configuration and name will now be used for every scenario in our test run.

### Adapting to your features
Adapting a set of existing tests which already use Capybara to control a browser is relatively simple.  
1.  Include `sauce_capybara_driver.rb` and `simple_sauce_setup.rb` in your `features/support` folder
2.  Edit your env.rb to set your desired platform
3.  Add the `Around` block from lines 5 to 8 of this example's `env.rb`
4.  Ensure you remove any `Capybara.current_driver` or `Capybara.javscript_driver` lines, to stop Capybara from switching to other drivers.

If you're using tagging to control which driver Capybara uses, you can add a tag for the LightSauce driver by adding the following block to your `env.rb`:

```ruby
Before '@sauce' do
  Capybara.current_driver = :light_sauce
end
```