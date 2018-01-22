//@Skip()
@Timeout(const Duration(seconds: 45))
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'dart:io';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  const String url = "https://www.gyerunkanyukam.hu/";
  WebDriver driver;

  group("Request Response Test |", () {
    var responseCode;
    HttpClient client;

    setUp(() {
      client = new HttpClient();
    });

    tearDown(() {
      client.close();
    });

    test(
        'Test #1: Loading the site returns valid content with 200 response code ',
        () async {
      await client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
        return request.close();
      }).then((HttpClientResponse response) {
        responseCode = response.statusCode;
      });
      expect(responseCode == 200, true);
    });
  });

  group("Basic Navigation Tests |", () {
    setUpAll(() async {
      startSelenium();
      driver = await setupWebDriver(1280, 1024);
    });

    tearDownAll(() {
      driver.quit();
    });

    test('Test #2: Check base url navigates to /home', () async {
      await driver.get(url);
      await waitForAngular(driver);
      expect(await driver.currentUrl, endsWith('/home'));
    }, timeout: new Timeout.factor(2));

    test('Test #3: Check there is no error messages in the console', () async {
      bool hasErrors = false;
      await driver.get(url);
      await waitForAngular(driver);
      await sleep5();
      hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
      expect(await hasErrors, false);
    });

    test('Test #4: Check at least 4 elements in the "Szolgaltatasok" menu',
        () async {
      await driver.get(url);
      await waitForAngular(driver);
      var servicesBtn = await driver.findElement(
          const By.cssSelector('div.menu-item.menu-item--services > a'));
      await servicesBtn.click();
      await sleep2();
      var menuItemsLength = await driver
          .findElements(const By.cssSelector(
              'div.menu-item.menu-item--services > div.nav-menu > div.menu-item'))
          .length;
      print("Services menu elements found: " + menuItemsLength.toString());
      expect(await isXAtLeastValueOfY(menuItemsLength, 4), true);
    });

    test(
        'Test #5: Check "Szolgaltatasok" menu contains an instance of "Videotar',
        () async {
      await driver.get(url);
      await waitForAngular(driver);
      var servicesBtn = await driver.findElement(
          const By.cssSelector('div.menu-item.menu-item--services > a'));
      await servicesBtn.click();
      var videotarService = await driver.findElement(const By.xpath(
          "*//div[contains(@class,'menu-item')]/a[contains(text(),'Vide')]"));
      expect(await elementExists(videotarService), true);
    });

    test('Test #6: Check login redirects to login page', () async {
      await driver.get(url);
      await waitForAngular(driver);
      var loginBtn = await driver.findElement(
          const By.cssSelector('div.menu-item.menu-item--login > a'));
      await loginBtn.click();
      expect(await driver.currentUrl, endsWith('/login'));
    });
  });
}
