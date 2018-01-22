//@Skip()
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  WebDriver driver;
  const String url = "https://www.gyerunkanyukam.hu/";

  setUpAll(() async {
    startSelenium();
    driver = await setupWebDriver(1280, 1024);
  });

  tearDownAll(() {
    driver.quit();
  });

  group("Workouts Page Tests |", () {
    test('Test #14: Check there is at least 6 video elements under /workouts',
        () async {
      await driver.get(url + "workouts");
      await waitForAngular(driver);
      await sleep5();
      var videoItems = await driver
          .findElements(const By.cssSelector(
              'video-summary-list > div.training-type-list > div '
              '> video-summary > div.video-summary'))
          .length;
      await waitForAngular(driver);
      print("Videos Found: " + videoItems.toString());
      expect(await isXAtLeastValueOfY(videoItems, 6), true);
    });
  });

  group("Workouts Page Tests | Formatorna Light |", () {
    setUpAll(() async {
      await driver.get(url + "video/view/formatorna-light");
      await waitForAngular(driver);
      await sleep5();
    });

    test('Test #15: Check at least 5 elements (rows) under "Hol érhető el?"',
        () async {
      var videosLength = await driver
          .findElements(const By.xpath(
              '*//workout-video-list/table/tbody/tr/td[1]/tag-representation/span'))
          .length;
      await waitForAngular(driver);
      print("Available Programs: " + videosLength.toString());
      expect(await isXAtLeastValueOfY(videosLength, 5), true);
    });

    test('Test #16: Check at least 1 "Videótár" under "Hol érhető el?',
        () async {
      var videotarOccurrences = await driver
          .findElements(const By.xpath(
              '*//workout-video-list/table/tbody/tr/td/a[contains(@href, "video")]'))
          .length;
      await waitForAngular(driver);
      print("Occurrences of videotar: " + videotarOccurrences.toString());
      expect(await isXAtLeastValueOfY(videotarOccurrences, 1), true);
    });

    test('Test #17: Box on left side of page has data not just labels',
        () async {
      var descLinesLength = await driver
          .findElements(
              const By.xpath('*//video-short-description/div/table/tbody/tr'))
          .length;
      var valuesLength = await driver
          .findElements(
              const By.xpath('*//video-short-description/div/table/tbody'
                  '/tr/td[2]'))
          .length; //[. !='']
      await waitForAngular(driver);
      expect(await isXAtLeastValueOfY(descLinesLength, 1), true);
      expect(await isXAtLeastValueOfY(valuesLength, descLinesLength), true);
    });
  });
}
