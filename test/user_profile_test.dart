//@Skip()
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  WebDriver driver;
  const String url = "https://www.gyerunkanyukam.hu/";
  var oldUserEmail = "connor_stansfield@live.com";
  var allUserPassword = "password123%";

  setUpAll(() async {
    startSelenium();
    driver = await setupWebDriver(1280, 1024);
  });

  tearDownAll(() {
    driver.quit();
  });

  group('Scores Page Tests |', () {
    setUpAll(() async {
      await driver.get(url + "login");
      await loginUserWithCredentials(
          oldUserEmail, allUserPassword, driver, true);
      await waitForAngular(driver);
      await sleep2();
      await driver.get(url + "profile/scores");
      await waitForAngular(driver);
      await sleep2();
    });

    test('Test #21: After login, Check user shows on all Highscore lists',
        () async {
      var userScore =
          await driver.findElement(const By.xpath('*//scores-list/div'
              '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
      expect(await elementExists(userScore), true);
    });

    test(
        'Test #22 (Örökranglista): Scores Page Birth-List Tab has data and includes users name',
        () async {
      var birthListTab = await driver.findElement(const By.xpath(
          '*//dumb-tab-panel/nav/a[contains(text(), "ranglista")]'));
      await birthListTab.click();
      var userScore =
          await driver.findElement(const By.xpath('*//scores-list/div'
              '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
      expect(await elementExists(userScore), true);
    });

    test(
        'Test #23 (30 napos): Scores Page 30-Days Tab has data and includes users name',
        () async {
      var thirtyDaysTab = await driver.findElement(
          const By.xpath('*//dumb-tab-panel/nav/a[contains(text(), "napos")]'));
      await thirtyDaysTab.click();
      var userScore =
          await driver.findElement(const By.xpath('*//scores-list/div'
              '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
      expect(await elementExists(userScore), true);
    });
  });

  test(
      'Test #24 (egy hónapban): Scores Page 1-Month-Ago Tab has data and includes users name',
      () async {
    await driver.get(url + "login");
    await loginUserWithCredentials(oldUserEmail, allUserPassword, driver, true);
    await waitForAngular(driver);
    await sleep2();
    await driver.get(url + "profile/scores");
    await waitForAngular(driver);
    await sleep2();
    var oneMonthAgoTab = await driver.findElement(const By.xpath(
        '*//dumb-tab-panel/nav/a[contains(text(), "Velem egy")]'));
    await oneMonthAgoTab.click();
    var userScore = await driver.findElement(const By.xpath('*//scores-list/div'
        '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
    expect(await elementExists(userScore), true);
  });
}
