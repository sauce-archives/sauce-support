import unittest
from appium import webdriver
from appium.webdriver.common.touch_action import TouchAction
from time import sleep


class PythonTest(unittest.TestCase):
    def setUp(self):
        caps = {}
        caps['platformName'] = 'iOS'
        caps['platformVersion'] = '7.1'
        caps['deviceName'] = 'iPhone Simulator'
        caps['app'] = 'https://github.com/appium/appium/raw/master/assets/TestApp7.1.app.zip'
        caps['appium-version'] = '1.2.4'
        caps['name'] = 'iOS Appium Example'

        self.driver = webdriver.Remote(
            desired_capabilities=caps,
            command_executor="http://<USER>:<KEY>@ondemand.saucelabs.com:80/wd/hub"
        )
        self.driver.implicitly_wait(5)

    def test_sauce(self):
	el = self.driver.find_element_by_ios_uiautomation('.elements()[2]')
	el.is_displayed()
        action = TouchAction(self.driver)
	action.tap(el).perform()

    def tearDown(self):
        print("Link to your job: https://saucelabs.com/jobs/%s" % self.driver.session_id)
        self.driver.quit()

if __name__ == '__main__':
    unittest.main()
