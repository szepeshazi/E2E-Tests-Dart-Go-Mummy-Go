import 'angular_utils.dart';
import 'dart:math';
import 'package:webdriver/io.dart';
import 'package:random_string/random_string.dart' as random;
import 'dart:async';
import 'dart:io';

bool _testingStarted = false;

void startSelenium() {
  if (!_testingStarted) {
    _testingStarted = true;
    print("Starting Selenium Chrome Driver");
    Process.run(
        'java.exe -Ddriver.chrome.driver=chromedriver.exe -jar '
        'selenium-server-standalone-3.6.0.jar',
        []);
  } else {
    print("Selenium Already Running");
  }
}

void stopSelenium() {
  print("Stopping Selenium Chrome Driver");
  Process.run("taskkill /im java.exe /f", []);
}

Future<WebDriver> setupWebDriver(int width, int height) async {
  var options = {'browserName': 'chrome'};
  WebDriver driver = await createDriver(desired: options);
  driver.logs
      .get('browser')
      .where((LogEntry l) => l.level == 'SEVERE')
      .listen((LogEntry l) => print(l));
  await (await driver.window).setSize(new Rectangle<int>(0, 0, width, height));
  return driver;
}

Future navigateToPage(WebDriver driver, String slug) async {
  await driver.get("https://www.gyerunkanyukam.hu/" + slug);
}

Future<String> signUpNewRandomUser(WebDriver driver, String pw) async {
  var newRandomUserEmail;
  var loginBtn = await driver
      .findElement(const By.cssSelector('div.menu-item.menu-item--login > a'));
  await loginBtn.click();
  var signUpBtn = await driver
      .findElement(const By.xpath('//*//tab-button[2]/material-ripple'));
  await signUpBtn.click();
  var signUpEmail = await driver.findElement(const By.xpath(
      '*//label[contains(@class,"input-container")]/input[contains(@type,"email")]'));
  newRandomUserEmail = generateRandomEmail();
  await signUpEmail.sendKeys(newRandomUserEmail);
  var signUpPW = await driver.findElement(const By.xpath(
      '*//label[contains(@class,"input-container")]/input[contains(@type,"password")]'));
  await signUpPW.sendKeys(pw);
  var termsRadioBtn = await driver.findElement(const By.xpath(
      "*//material-checkbox/div[contains(@class, 'icon-container')]/material-ripple"));
  await termsRadioBtn.click();
  var submitBtn =
      await driver.findElement(const By.xpath('*//input[@type="submit"]'));
  await submitBtn.click();
  await waitForAngular(driver);
  await sleep5();
  return newRandomUserEmail;
}

Future loginUserWithCredentials(
    String username, String pw, WebDriver driver, bool removeOverlay) async {
  bool loggedIn = await isLoggedIn(driver);
  if (loggedIn) {
    print("loginUserWithCredentials: Already logged in, logging out");
    await logoutUser(driver);
  }
  print("loginUserWithCredentials: Logging in as " + username);
  await navigateToPage(driver, "login");
  await waitForAngular(driver);
  await sleep10();
  var loginTabBtn = await driver
      .findElement(const By.xpath('*//tab-button[1]/material-ripple'));
  await loginTabBtn.click();
  var loginEmail = await driver.findElement(const By.xpath(
      '*//label[contains(@class,"input-container")]/input[contains(@type,"email")]'));
  await loginEmail.sendKeys(username);
  var loginPW = await driver.findElement(const By.xpath(
      '*//label[contains(@class,"input-container")]/input[contains(@type,"password")]'));
  await loginPW.sendKeys(pw);
  var submitBtn =
      await driver.findElement(const By.xpath('*//input[@type="submit"]'));
  await submitBtn.click();
  await waitForAngular(driver);
  if (removeOverlay) {
    await sleep10();
    await dismissOverlay(driver);
  }
  print(
      "loginUserWithCredentials: Logged in as user " + username + " pw: " + pw);
}

Future dismissOverlay(WebDriver driver) async {
  var continueBtn;
  try {
    await waitForAngular(driver);
    continueBtn = await driver.findElement(const By.cssSelector(
        'product-module > cutout-shadow-overlay > div > div.cutout'));
  } on NoSuchElementException catch (e) {
    print("dismissOverlay: overlay element not found.");
  } catch (exception, stackTrace) {
    print("Exceptions caught");
    print(exception);
    print(stackTrace);
  } finally {
    if (elementExists(continueBtn)) {
      await continueBtn.click();
    }
    print("dismissOverlay: dismissed cutout-shadow-overlay.");
    await waitForAngular(driver);
  }
}

Future logoutUser(WebDriver driver) async {
  bool loggedIn = await isLoggedIn(driver);
  var profileBtn;
  var logoutBtn;
  if (loggedIn) {
    try {
      await waitForAngular(driver);
      profileBtn = await driver
          .findElement(const By.cssSelector('div.menu-item--profile > a'));
      logoutBtn = await driver.findElement(const By.xpath(
          '*//div[contains(@class, "menu-item")]/a/span[contains(text(), "Kilépés")]'));
    } on NoSuchElementException catch (e) {
      print("logoutUser: Logout element(s) not found.");
    } catch (exception, stackTrace) {
      print("Exceptions caught:");
      print(exception);
      print(stackTrace);
    } finally {
      if (elementExists(profileBtn) && elementExists(logoutBtn)) {
        await profileBtn.click();
        await logoutBtn.click();
      }
      print("logoutUser: Logged out");
      await waitForAngular(driver);
    }
  } else {
    print("logoutUser: User wasnt logged in");
  }
}

Future<bool> isLoggedIn(WebDriver driver) async {
  var profilePicture = null;
  bool loggedIn = false;
  try {
    await waitForAngular(driver);
    profilePicture = await driver.findElement(const By.cssSelector(
        'nav > div > div > div.menu-item--profile > a > account-picture'));
  } on NoSuchElementException catch (e) {
    print("isLoggedIn: Logged-in-profile element not found.");
  } catch (exception, stackTrace) {
    print("Exceptions caught");
    print(exception);
    print(stackTrace);
  } finally {
    loggedIn = elementExists(profilePicture);
    return loggedIn;
  }
}

Future clickMegvasarlom (WebDriver driver, String productSlug) async {
  await navigateToPage(driver, productSlug);
  await waitForAngular(driver);
  await sleep5();
  var btnBuy = await driver.findElement(const By.xpath(
      "*//div[contains(@class, 'package-details')]/material-button/material-ripple"));
  await btnBuy.click();
  await waitForAngular(driver);
  await sleep5();
}

Future<bool> checkForConsoleErrors(WebDriver driver, String logLevel) async {
  bool hasErrors = false;
  await driver.logs
      .get('browser')
      .where((LogEntry l) => l.level == logLevel)
      .toList()
      .then((logs) {
    if (logs.length > 0) {
      logs.forEach(print);
      hasErrors = true;
    }
  });
  return hasErrors;
}

String generateRandomEmail() {
  return random.randomAlphaNumeric(10) + "@email.com";
}

Future sleep10() {
  return new Future.delayed(const Duration(seconds: 10), () => "10");
}

Future sleep5() {
  return new Future.delayed(const Duration(seconds: 5), () => "5");
}

Future sleep2() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}

bool futureElementExists(Stream<WebElement> e) {
  return (e != null);
}

bool elementExists(WebElement e) {
  return (e != null);
}

bool isXAtLeastValueOfY(num x, num y) {
  return (x >= y);
}

bool isXLessThanY(num x, num y) {
  return (x < y);
}
