

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class UserModuleTesting {
    WebDriver driver;

    @BeforeTest
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe");
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    @Test(priority = 1)
    public void testUserRegistration() {
        driver.get("http://yourwebsite.com/register");
        driver.findElement(By.id("name")).sendKeys("Test User");
        driver.findElement(By.id("email")).sendKeys("testuser@example.com");
        driver.findElement(By.id("password")).sendKeys("Test@123");
        driver.findElement(By.id("confirmPassword")).sendKeys("Test@123");
        driver.findElement(By.id("registerBtn")).click();
        
        WebElement successMessage = driver.findElement(By.id("registrationSuccess"));
        Assert.assertEquals(successMessage.getText(), "Registration Successful");
    }

    @Test(priority = 2, dataProvider = "loginData")
    public void testUserLogin(String email, String password, String expectedMessage) {
        driver.get("http://yourwebsite.com/login");
        driver.findElement(By.id("email")).sendKeys(email);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("loginBtn")).click();
        
        WebElement message = driver.findElement(By.id("loginMessage"));
        Assert.assertEquals(message.getText(), expectedMessage);
    }

    @DataProvider(name = "loginData")
    public Object[][] loginData() {
        return new Object[][] {
            {"testuser@example.com", "Test@123", "Login Successful"},
            {"wronguser@example.com", "wrongpass", "Invalid credentials"}
        };
    }

    @Test(priority = 3)
    public void testReportFraudByUser() {
        driver.get("http://yourwebsite.com/report");
        driver.findElement(By.id("fraudNumber")).sendKeys("+911234567890");
        driver.findElement(By.id("fraudDescription")).sendKeys("Fake call claiming bank verification.");
        driver.findElement(By.id("submitReport")).click();
        
        WebElement successMessage = driver.findElement(By.id("reportSuccess"));
        Assert.assertEquals(successMessage.getText(), "Fraud Report Submitted Successfully");
    }

    @Test(priority = 4)
    public void testSubmitComplaintByUser() {
        driver.get("http://yourwebsite.com/complaint");
        driver.findElement(By.id("fullName")).sendKeys("Test User");
        driver.findElement(By.id("email")).sendKeys("testuser@example.com");
        driver.findElement(By.id("phone")).sendKeys("9876543210");
        driver.findElement(By.id("description")).sendKeys("Unauthorized transaction on my bank account.");
        driver.findElement(By.id("submitComplaint")).click();
        
        WebElement confirmation = driver.findElement(By.id("complaintConfirmation"));
        Assert.assertEquals(confirmation.getText(), "Complaint Submitted Successfully");
    }

    @AfterTest
    public void teardown() {
        driver.quit();
    }
}
