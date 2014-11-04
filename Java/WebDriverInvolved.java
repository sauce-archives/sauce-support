import java.net.URL;
import java.util.concurrent.TimeUnit;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

public class WebDriverInvolved {
  public static void main(String[] args) throws Exception {
    WebDriver driver;

    DesiredCapabilities capabilities = new DesiredCapabilities();
    capabilities.setCapability("browserName", "Chrome");
    capabilities.setCapability("version", "36");
    capabilities.setCapability("name", "Involved Java WebDriver Test");

    System.out.println("Running on Sauce Labs...");
    driver = new RemoteWebDriver(new URL("http://YOUR_USERNAME:YOUR_ACCESS_KEY@ondemand.saucelabs.com:80/wd/hub"), capabilities);
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);

    driver.get("https://saucelabs.com/test/guinea-pig");
    System.out.println("Page title is: " + driver.getTitle());

    //Find contents of a div
    WebElement div = driver.findElement(By.id("i_am_an_id"));
    System.out.println("Output of element: " + div.getText());

    //Clear the 'i has no focus' textbox
    WebElement textbox = driver.findElement(By.name("i_am_a_textbox"));
    textbox.clear();

    //Check uncheckedBox
    WebElement uncheckedBox = driver.findElement(By.name("unchecked_checkbox"));
    if( !uncheckedBox.isSelected() ) {
      uncheckedBox.click();
    }

    //UnCheck checkedBox
    WebElement checkedBox = driver.findElement(By.name("checked_checkbox"));
    checkedBox.click();

    //Fill out email
    WebElement email = driver.findElement(By.id("fbemail"));
    email.sendKeys("thebestemail@ever.hi");

    //Fill out comments
    WebElement comment = driver.findElement(By.id("comments"));
    comment.sendKeys("Hello, I'm currently running a test on Sauce Labs :).");

    //Click send
    WebElement submit = driver.findElement(By.id("submit"));
    submit.click();

    //Output comments: changed
    WebElement your_comment = driver.findElement(By.id("your_comments"));
    System.out.println("Output of your_comments: " + your_comment.getText());

    //Closing down the WebDriver
    driver.quit();

    System.out.println("Done! View this test on your dashboard at https://saucelabs.com/tests");
  }
}
