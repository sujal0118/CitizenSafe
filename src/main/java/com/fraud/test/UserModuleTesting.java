package com.fraud.test;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.ITestResult;
import org.testng.annotations.*;
import io.github.bonigarcia.wdm.WebDriverManager;
import java.time.Duration;

public class UserModuleTesting {
    WebDriver driver;
    WebDriverWait wait;
    String baseAppUrl = "http://localhost:10932/FraudDetectionSystem/";
    boolean allTestsPassed = true;

    @BeforeTest
    public void setup() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        driver.manage().window().maximize();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        System.out.println("Browser setup completed.");
    }

    // Helper methods
    private void enterText(By locator, String text) {
        WebElement element = wait.until(ExpectedConditions.elementToBeClickable(locator));
        element.clear();
        element.sendKeys(text);
    }

    private void clickButton(By locator) {
        WebElement element = wait.until(ExpectedConditions.elementToBeClickable(locator));
        element.click();
    }

    private boolean isElementPresent(By locator) {
        try {
            wait.until(ExpectedConditions.presenceOfElementLocated(locator));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // Test case: User login
    @Test(priority = 1, dataProvider = "loginData")
    public void testUserLogin(String email, String password, String expectedOutcome) {
        driver.get(baseAppUrl + "login.jsp");
        enterText(By.id("loginEmail"), email);
        enterText(By.id("loginPassword"), password);
        clickButton(By.id("loginBtn"));

        wait.until(ExpectedConditions.or(
            ExpectedConditions.urlContains("index.jsp"),
            ExpectedConditions.presenceOfElementLocated(By.id("modalDialog"))
        ));

        String actualUrl = driver.getCurrentUrl();
        if (actualUrl.contains("index.jsp")) {
            Assert.assertEquals(driver.getTitle(), expectedOutcome, "Unexpected page title after login!");
        } else if (isElementPresent(By.id("modalDialog"))) {
            WebElement errorModal = driver.findElement(By.id("modalDialog"));
            Assert.assertEquals(errorModal.getText().trim(), expectedOutcome, "Unexpected error message!");
            System.out.println("POSITIVE: All tests passed successfully!");
        } else {
            Assert.fail("Unexpected behavior: Neither successful login nor error message detected.");
        }
    }

    // Test case: Submit fraud report
//    @Test(priority = 2, dataProvider = "reportData")
//    public void testSubmitFraudReport(String email, String password, String noOrUrl, String date, String description, String expectedMessage) {
//        driver.get(baseAppUrl + "login.jsp");
//        enterText(By.id("loginEmail"), email);
//        enterText(By.id("loginPassword"), password);
//        clickButton(By.id("loginBtn"));
//        wait.until(ExpectedConditions.urlContains("index.jsp"));
//
//        driver.get(baseAppUrl + "reportfraud.jsp");
//        enterText(By.id("no_orurl"), noOrUrl);
//        
//        WebElement dateInput = driver.findElement(By.id("date"));
//        ((JavascriptExecutor) driver).executeScript("arguments[0].removeAttribute('readonly');", dateInput);
//        dateInput.clear();
//        dateInput.sendKeys(date);
//
//        enterText(By.id("description"), description);
//        clickButton(By.id("submitReportBtn"));
//
//        WebElement messageElement = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("reportMessage")));
//        Assert.assertEquals(messageElement.getText(), expectedMessage, "Report submission message mismatch!");
//    }

    // Data providers
    @DataProvider(name = "loginData")
    public Object[][] loginData() {
        return new Object[][]{
            {"sujalja396@gmail.com", "12345678", "Citizen Safe"},
            {"wronguser@example.com", "wrongpass", "User not found. Please register.\nOK"}
        };
    }

//    @DataProvider(name = "reportData")
//    public Object[][] reportData() {
//        return new Object[][]{
//            {"sujalja396@gmail.com", "12345678", "www.fraudsite.com", "2025-03-01", "Scam website selling fake products", "Report submitted successfully."},
//            {"sujalja396@gmail.com", "12345678", "9876543210", "2025-03-02", "Fraud call demanding OTP", "Report submitted successfully."}
//        };
//    }

    @AfterMethod
    public void checkTestResult(ITestResult result) {
        if (!result.isSuccess()) {
            allTestsPassed = false;
        }
    }

    @AfterTest
    public void teardown() {
        if (driver != null) {
            driver.quit();
            System.out.println("Browser closed successfully.");
        }
        
        if (allTestsPassed) {
            System.out.println("POSITIVE: All tests passed successfully!");
        } else {
            System.out.println("NEGATIVE: Some tests failed. Check the logs for details.");
        }
    }
}
