Using Standalone Jasmine 2+ with Sauce Labs and Grunt
=====================================================

What This Example Covers
------------------------
* Connecting Jasmine 2.1.3 and up with Sauce Labs
* Reporting results to Sauce Labs with grunt-saucelabs
* Running tests on multiple platforms
* Starting and Stopping Sauce Connect with grunt-saucelabs

What This Example Does Not Cover
--------------------------------
* How Jasmine Works

Pre-requisites
--------------
* A Sauce Labs account
* Node.js installed
* NPM installed
* The SAUCE_USERNAME environment variable, set to your Sauce Username
* The SAUCE_ACCESS_KEY environment variable, set to your Sauce Access Key
* Experience with Jasmine

Running The Example
-------------------

First, open a terminal window and navigate to this directory.  Then, install all of the dependencies:

```bash
$ npm install
```

Once they're all installed, you're ready to test:

```bash
$ grunt test
```

You should see output that ends with something like so:
```bash
Tested http://127.0.0.1:9999/test-jasmine/SpecRunner.html
Platform: linux,googlechrome,
Passed: true
Url https://saucelabs.com/jobs/a5fa50d3e5424bed8c1c91d29047786e


Tested http://127.0.0.1:9999/test-jasmine/SpecRunner.html
Platform: XP,firefox,19
Passed: true
Url https://saucelabs.com/jobs/b66d2421d2ff4280a215990cf6c10c19


Tested http://127.0.0.1:9999/test-jasmine/SpecRunner.html
Platform: XP,googlechrome,
Passed: true
Url https://saucelabs.com/jobs/065c2d538d8948d5a598d93c86c0e673


Tested http://127.0.0.1:9999/test-jasmine/SpecRunner.html
Platform: WIN8,internet explorer,10
Passed: true
Url https://saucelabs.com/jobs/36faf411643b4a0983c15d2e6b3cf3df
>> All tests completed with status true
=> Stopping Tunnel to Sauce Labs

Done, without errors.
```

How It Works
------------
The grunt-saucelabs plugin is doing the majority of the work here, providing us with a Sauce Connect tunnel, support for multiple browsers, and managing sessions with Sauce Labs.  It's been configured in Gruntfile.js

We've downloaded the standalone version of Jasmine 2.1.3 and unpacked it in the `test-jasmine` directory.

Because Jasmine 2 differs in how it exposes test results, we've used the jasmine-jsreporter project to allow Sauce Labs to read test outcomes.  This we hook up in `test-jasmine/SpecRunner.html`

###Gruntfile.js
The Gruntfile is responsible configuring our browsers, the saucelabs-jasmine library and our webserver.

On lines 2 - 16, we're defining an array of browsers to test against.  These are taken from the [Sauce Labs Platform Page](https://saucelabs.com/platforms).

Lines 19-26 configure the connect webserver, telling it to start up on port 9999.  This port is arbitrary, but it does need to be one of the [valid Sauce Connect ports](https://docs.saucelabs.com/reference/sauce-connect/#can-i-access-applications-on-localhost-).

On lines 27-38, we're configuring the saucelabs-jasmine task that comes as part of the saucelabs-grunt library.

The most important things here the "Urls", "browsers" and "concurrency" properties.

The `urls` property tells Sauce Labs' VMs to open Jasmine's SpecRunner.html page, kicking off the tests.  It's relative to localhost because Sauce Connect will let us access local resources.  We've used the port which we're starting the connect webserver on.

The `browsers` property is the array of browsers to run each test against.  We've set it to be the same as the `browsers` object we created on lines 2 - 16.  We could have created this array inline, but placing it at the top of the file makes things more readable.

The `concurrency` property controls how many tests can be running on Sauce Labs at any given time.  Each browser you provide will be a separate Sauce Labs test.  This should be set no higher then the concurrency your Sauce Labs account has access too.

###jasmine-jsreporter.js
The jasmine-jsreporter.js project makes it easier to extract information about Jasmine test results, without having to parse the dom.  It was written by @detro and can be found at https://github.com/detro/jasmine-jsreporter.

We've simply taken the entire file and placed it in the `test-jasmine/lib` directory, at `test-jasmine/lib/jasmine-jsreporter.js`

###SpecRunner.html
The `SpecRunner.html` file is provided by Jasmine, and can be found at `test-jasmine/SpecRunner.html`.  It is this file which sets Jasmine up, loads its libraries and configures which specs to run.

Lines 1-12 are unaltered.  On lines 10-12 the page loads the Jasmine libraries.

Line 13 we added by hand.  Here, we load the `jasmine-jsreporter.js` file so that it's available for use.

On line 16 we've replaced the source files for the example project provided by Jasmine with source files of our own.  We've also replaced the example spec files with our own, on line 19.

Lines 21-24 are the most important change we've made.  By default, Jasmine 2 does not expose results in a form which can be parsed by Sauce Labs.  On line 23, we register the JSReporter2 reporter with Jasmine.  This is a reporter provided by the jasmine-jsreporter project, and is what allows us to parse out the results of the tests.

Configuring your own Jasmine tests
----------------------------------

There is only a small amount of configuration which we've had to do here.  To adapt an existing standalone Jasmine installation to run on Sauce Labs, you need to add and configure grunt-saucelabs, and make Jasmine use the jasmine-jsreporter.

### Adding and Configuring grunt-saucelabs
1.  Add 'grunt-saucelabs' to your package.json file
2.  Configure the 'saucelabs-jasmine' grunt task.  You can find a full list of configuration details [here](https://github.com/axemclion/grunt-saucelabs) but the most important are 'urls', 'browers' and 'concurrency'.  See this project's `Gruntfile.js` for an example.
3.  Ensure a webserver will be running before the tests.  In this example, we've used the connect webserver.  If you're testing against a staging or other server, this might not be required.  This server must be running on one of the [valid Sauce Connect ports](https://docs.saucelabs.com/reference/sauce-connect/#can-i-access-applications-on-localhost-).

You can find Sauce Labs' available platforms at our [platforms page](http://www.saucelabs.com/platforms).

### Using the jasmine-jsreporter
1.  Download the jasmine-jsreporter.js file from https://github.com/detro/jasmine-jsreporter and make it available somewhere in your path.
2.  Require the file inside your SpecRunner.html (see line 13 of `test-jasmine/SpecRunner.html`)
3.  Use Jasmine's `addReporter` method to add a new instance of the `jasmine.JSReporter2` object to Jasmine's environment.  This makes the results of your Jasmine tests available from `window.jasmine.getJSReport()`.  See lines 21-24 of `test-jasmine/SpecRunner.html` for an example