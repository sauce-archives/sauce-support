Sauce with a Rack Application, using RSpec and Capybara
--------------------------------------------------------

If you're running a Rack application you're wishing to test with Capybara, much of the server startup is handled for you;  There are just a couple of integration points to take care of.

Setting up your tests like this will allow you to run tests in serial or parallel.

Notable Bits
============

Check out '/spec/sauce_helper.rb'.

How it Works
============

The Sauce gem, be default, will configure Capybara to use one of the [Sauce Connect Ports](https://docs.saucelabs.com/reference/sauce-connect/#can-i-access-applications-on-localhost-) and then spin up a server when tests are run.