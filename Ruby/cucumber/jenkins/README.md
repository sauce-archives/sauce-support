Cucumber and Capybara, on Jenkins
---------------------------------

What this example covers
========================

This example covers a simple setup for running Cucumber tests with Capybara, using Sauce Labs as the browsers behind Capybara.  It reports job results to the [Jenkins Sauce OnDemand Plugin](https://docs.saucelabs.com/ci-integrations/jenkins/#installing-the-jenkins-sauce-ondemand-plugin).

What this example does not cover
================================

This example does not:
  * Do build or tag metadata
  * Use Sauce Connect
  * Run on multiple platforms automatically
  * Replace the [Sauce Labs Jenkins Tutorial](https://docs.saucelabs.com/ci-integrations/jenkins)

Pre-requisites
==============

You will need a working Jenkins instance, with your Cucumber project already running within Jenkins and connecting to Sauce Labs

Running the example
===================

```bash
    $ bundle exec cucumber
```

You should see:

```
    SauceOnDemandSessionID=SomeSessionID job-name=Navigating somewhere else - Going to fhdgest.com

    SauceOnDemandSessionID=AnotherSessionID job-name=Navigating somewhere - Going to bees.com
```

How it works & Adapting to your tests
=====================================

Adapt this example to your tests by following the (Sauce Labs Jenkins Tutorial)[https://docs.saucelabs.com/ci-integrations/jenkins] for the '*Installing*' and '*Configuring*' steps (but skip checking the '*Enable Sauce Connect?*' box for now)
The Jenkins Sauce OnDemand plugin requires two things in order to embed Sauce Labs job reports; a JUnit format XML test result report, and console lines indicating the session and name of each test run.


### JUnit XML Output

Jenkins requires test results in the form of a JUnit style XML file.  Luckily, Cucumber includes a formatter to output these files, saving us from having to include another gem (or hand cut XML *shudder*).

This example uses the `cucumber.yml` file in the `config` directory to define a profile, called `jenkins`:

```jenkins:  --format junit --OUT ./```

This profile uses the junit formatter, and outputs to the root directory of the project.  The formatter names files 'TEST-features-#{featurename}.xml'.

We're using some ERB to check if the '*JENKINS_SERVER_COOKIE*' environment variable is present, and if it is, use the jenkins profile by default.

In your Jenkins project config, select the '*Publish JUnit test result report*' option from the '**Add post-build action**' dropdown meny.  In the '**Test report XMLs**' field, enter a path matching the output location of the Cucumber junit formatter.  For our example, it's ```TEST-*.xml```.


### Jenkins Sauce OnDemand Output logging

The Jenkins Sauce OnDemand Plugin needs to see the names and Sauce Job IDs in your test output.  It expects to see these in the format:

```ruby
    # session_id is the Sauce Job ID
    # name is the test's name, published to Sauce Labs
    "SauceOnDemandSessionID=#{session_id} job-name=#{name}"
```

You can do this in your features by: 
* copying the Around hook from `/features/support/env.rb` into your project's `/features/support/env.rb`
* copying the entire `/features/support/jenkins_sauce.rb' file into your project's `/features/support` directory
* ensuring all your Scenarios are tagged with `@selenium`

In `features/support/env.rb`, we define an Around hook for all features tagged with `@selenium`:

```ruby
    Around('@selenium') do |scenario, block|
      JenkinsSauce.output_jenkins_log(scenario)
      block.call
      ::Capybara.current_session.driver.quit
    end
```

The JenkinsSauce module is defined in `features/support/jenkins_sauce.rb`, and the `output_jenkins_log` method gets the Sauce Job ID and feature name, and outputs them.

The Sauce Job ID is relatively simple;  It's the session ID of your Selenium Webdriver, and once Capybara has started a WebDriver instance, you can obtain it like this:

```ruby
    driver = ::Capybara.current_session.driver
    session_id = driver.browser.session_id 
```

Getting the job name can be more difficult.  Outline Rows and Scenarios have to be treated differently, and a feature can have multiple scenarios.  The `jenkins_name_from_scenario` method (`jenkins_sauce.rb:3) grabs the relevant variables from the Outline Row or Scenario running, mixes them together and returns them.

That's it!  You should now be set to run your Jenkins job with integrate Sauce reporting.