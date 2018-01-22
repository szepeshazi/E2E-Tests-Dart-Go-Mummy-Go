//@Skip()
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  WebDriver driver;
  const String url = "https://www.gyerunkanyukam.hu/";
  var newUserEmail = "connor.stansfield.development@gmail.com";
  var oldUserEmail = "connor_stansfield@live.com";
  var allUserPassword = "password123%";

  setUpAll(() async {
    startSelenium();
    driver = await setupWebDriver(1280, 1024);
  });

  tearDownAll(() {
    driver.quit();
  });

  group("Login And Registration Tests |", () {
    test('Test #7: Register a new user', () async {
      await driver.get(url);
      await waitForAngular(driver);
      await signUpNewRandomUser(driver, allUserPassword);
      await sleep10();
      var completedSignUp = await driver.findElement(const By.xpath(
          "*//input[contains(@value,'Megerősítő levél újraküldése')]"));
      await waitForAngular(driver);
      expect(await elementExists(completedSignUp), true);
    });

    test('Test #8: Login with a new user', () async {
      await loginUserWithCredentials(
          newUserEmail, allUserPassword, driver, true);
      await waitForAngular(driver);
      expect(await driver.currentUrl, contains('/probaidoszak'));
    });

    test('Test #9: Login with an old user', () async {
      await loginUserWithCredentials(
          oldUserEmail, allUserPassword, driver, false);
      await waitForAngular(driver);
      await sleep10();
      expect(await driver.currentUrl, contains('/profile'));
    });

    test('Test #10 User is not logged in by default', () async {
      await logoutUser(driver);
      await sleep2();
      await driver.get(url);
      await waitForAngular(driver);
      expect(await isLoggedIn(driver), false);
    });

    test('Test #11: Check there is a profile IMG after logging in', () async {
      await loginUserWithCredentials(
          oldUserEmail, allUserPassword, driver, true);
      await waitForAngular(driver);
      expect(await isLoggedIn(driver), true);
    });

    test(
        'Test #12: Check you see at least 8 elements under Szolgáltatásaink menu',
        () async {
      await logoutUser(driver);
      await sleep2();
      await driver.get(url);
      await waitForAngular(driver);
      var servicesBtn = await driver.findElement(
          const By.cssSelector('div.menu-item.menu-item--services > a'));
      await servicesBtn.click();
      var menuItemsLength = await driver
          .findElements(const By.xpath(
              '*//div[contains(@class, "menu-item--services")]/div[contains(@class,'
              ' "nav-menu")]/div[contains(@class, "menu-item")]'))
          .length;
      await waitForAngular(driver);
      expect(await isXAtLeastValueOfY(menuItemsLength, 8), true);
    });

    test(
        'Test #13: After login, there is at least 8 elements in Szolgáltatásaink menu',
        () async {
      await loginUserWithCredentials(
          oldUserEmail, allUserPassword, driver, true);
      await waitForAngular(driver);
      var profileBtn = await driver.findElement(
          const By.xpath('*//div[contains(@class, "menu-item--profile")]/a'));
      await profileBtn.click();
      var menuItemsLength = await driver
          .findElements(const By.xpath(
              '*//div[contains(@class, "menu-item--profile")]/div[contains'
              '(@class, "nav-menu")]/div[contains(@class, "menu-item")]'))
          .length;
      var trialPeriodItem = await driver.findElements(const By.xpath(
          '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
          '/a[contains(@href,"/profile/product/probaidoszak")]'));
      var settingsItem = await driver.findElements(const By.xpath(
          '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
          '/a[contains(@href,"/profile/settings")]'));
      var logoutItem = await driver.findElements(const By.xpath(
          '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
          '/a/span/font/font[contains(text(),"egress")]'));
      waitForAngular(driver);
      expect(isXAtLeastValueOfY(menuItemsLength, 3), true);
      expect(futureElementExists(trialPeriodItem), true);
      expect(futureElementExists(settingsItem), true);
      expect(futureElementExists(logoutItem), true);
    });
  });
}
