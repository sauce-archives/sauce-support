import java.net.URL;
import java.util.concurrent.TimeUnit;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

public class WebDriverBasic {
    public static void main(String[] args) throws Exception {
        WebDriver driver;

        DesiredCapabilities capabilities = new DesiredCapabilities();
        capabilities.setCapability("browserName", "Chrome");
        capabilities.setCapability("version", "36");
        capabilities.setCapability("name", "Basic Java WebDriver Test");

        System.out.println("Running on Sauce Labs...");
        driver = new RemoteWebDriver(new URL("http://YOUR_USERNAME:YOUR_ACCESS_KEY@ondemand.saucelabs.com:80/wd/hub"), capabilities);
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);

        driver.get("https://saucelabs.com/test/guinea-pig");
        System.out.println("Page title is: " + driver.getTitle());
        driver.quit();

        System.out.println("Done! View this test on your dashboard at https://saucelabs.com/tests");
    }
}
