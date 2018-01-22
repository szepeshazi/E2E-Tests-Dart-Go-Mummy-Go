//@Skip()
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  WebDriver driver;
  const String url = "https://www.gyerunkanyukam.hu/";
  var newUserEmail = "connor.stansfield.development@gmail.com";
  var allUserPassword = "password123%";

  setUpAll(() async {
    startSelenium();
    driver = await setupWebDriver(1280, 1024);
  });

  tearDownAll(() {
    driver.quit();
  });

  group("Probaidoszak Page Tests |", () {
    setUpAll(() async {
      await driver.get(url);
      await loginUserWithCredentials(
          newUserEmail, allUserPassword, driver, true);
      await navigateToPage(driver, 'profile/product/probaidoszak');
      await waitForAngular(driver);
      await sleep5();
    });

    test('Test #18: Check you see a bunch of videos showing up', () async {
      var videoItemsLength = await driver
          .findElements(const By.cssSelector(
              'video-summary-list > div.training-type-list > div '
              '> video-summary > div.video-summary'))
          .length;
      print("Video items found: " + videoItemsLength.toString());
      expect(await isXAtLeastValueOfY(videoItemsLength, 5), true);
    });

    test('Test #19: Try to play the video, check if the popup shows up on page',
        () async {
      var firstVideoItem;
      firstVideoItem = await driver.findElement(const By.xpath(
          '*//video-summary-list/div[contains(@class, "training-type-list")]//video-summary[1]'));
      await firstVideoItem.click();
      await sleep5();
      var videoPlayer = await driver.findElement(const By.xpath(
          '//*[@id="default-acx-overlay-container"]//vimeo-player/'
          'div[contains(@class,"modal-body")]/div/div/iframe'));
      await videoPlayer.click();
      await sleep2();
      await waitForAngular(driver);
      expect(await elementExists(videoPlayer), true);
    });

    test('Test #20: Check if the filtering options work', () async {
      await navigateToPage(driver, 'profile/product/probaidoszak');
      await waitForAngular(driver);
      await sleep5();
      var videoItemsLength = await driver
          .findElements(const By.cssSelector(
              'video-summary-list > div.training-type-list > div '
              '> video-summary > div.video-summary'))
          .length;
      print("Video items found: " + videoItemsLength.toString());
      var workoutVarietyFilterDropdown = await driver.findElement(
          const By.xpath('*//tag-set-filter/material-dropdown-select/'
              'dropdown-button/div/span[contains(text(), "Edz")]'));
      await workoutVarietyFilterDropdown.click();
      var jogaFilterOption = await driver.findElement(const By.xpath(
          '*//div[contains(@class, "options")]/div/material-select-dropdown-item/span[contains(text(), "jóga")]'));
      await jogaFilterOption.click();
      await waitForAngular(driver);
      await sleep2();
      var filteredVideoItemsLength = await driver
          .findElements(const By.cssSelector(
              'video-summary-list > div.training-type-list > div '
              '> video-summary > div.video-summary'))
          .length;
      print(
          "Filtered video items found: " + filteredVideoItemsLength.toString());
      expect(await isXAtLeastValueOfY(videoItemsLength, 5), true);
      expect(await isXAtLeastValueOfY(filteredVideoItemsLength, 1), true);
      expect(
          await isXLessThanY(filteredVideoItemsLength, videoItemsLength), true);
    });
  });

  group("Megvasarlom Product Page Tests |", () {
    setUpAll(() async {
      await loginUserWithCredentials(
          newUserEmail, allUserPassword, driver, true);
      await waitForAngular(driver);
    });

    test('Test #25: Check clicking on "Megvasarlom" throws no errors | The GWL',
        () async {
      bool hasErrors = false;
      await clickMegvasarlom(
          driver, 'product/view/a-nagy-sulyrakezdo-program-kezdo-szint');
      hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
      expect(await hasErrors, false);
    });

    test(
        'Test #26: Clicking on "Megvasarlom" throws no errors | Superhuman Program',
        () async {
      bool hasErrors = false;
      await clickMegvasarlom(driver, 'product/view/szuperhas-program');
      hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
      expect(await hasErrors, false);
    });
  });
}
