//@Skip()
@Timeout(const Duration(seconds: 45))
import 'angular_utils.dart';
import 'testing_utils.dart';
import 'dart:io';
import 'package:webdriver/io.dart';
import 'package:test/test.dart';

void main() {
  WebDriver driver;
  const String url = "https://www.gyerunkanyukam.hu/";
  var newUserEmail = "connor.stansfield.development@gmail.com";
  var oldUserEmail = "connor_stansfield@live.com";
  var allUserPassword = "password123%";

  group("http client |", () {
    group("request response tests |", () {
      var responseCode;
      HttpClient client;

      setUp(() {
        client = new HttpClient();
      });

      tearDown(() {
        client.close();
      });

      test('loading site returns valid content', () async {
        await client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
          return request.close();
        }).then((HttpClientResponse response) {
          responseCode = response.statusCode;
        });
        expect(responseCode == 200, true);
      });
    });
  });

  group("web driver |", () {
    setUpAll(() async {
      startSelenium();
      driver = await setupWebDriver(1280, 1024);
    });

    tearDownAll(() {
      stopSelenium();
      driver.quit();
      playCompletionBeep();
    });

    group("basic navigation tests |", () {
      setUp(() async {
        await driver.get(url);
        await waitForAngular(driver);
      });

      test('base url navigates home', () async {
        expect(await driver.currentUrl, endsWith('/home'));
      }, timeout: new Timeout.factor(2));

      test('there is no error messages in the console', () async {
        bool hasErrors = false;
        await sleep5();
        hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
        expect(await hasErrors, false);
      });

      test('at least 4 elements in the szolgaltatasok menu', () async {
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

      test('szolgaltatasok menu contains an instance of videotar', () async {
        var servicesBtn = await driver.findElement(
            const By.cssSelector('div.menu-item.menu-item--services > a'));
        await servicesBtn.click();
        var videotarService = await driver.findElement(const By.xpath(
            "*//div[contains(@class,'menu-item')]/a[contains(text(),'Vide')]"));
        expect(await elementExists(videotarService), true);
      });

      test('at least 8 elements under szolgaltatasaink menu', () async {
        await sleep2();
        var servicesBtn = await driver.findElement(
            const By.cssSelector('div.menu-item.menu-item--services > a'));
        await servicesBtn.click();
        var menuItemsLength = await driver
            .findElements(const By.xpath(
                '*//div[contains(@class, "menu-item--services")]/div[contains('
                    '@class, "nav-menu")]/div[contains(@class, "menu-item")]'))
            .length;
        await waitForAngular(driver);
        expect(await isXAtLeastValueOfY(menuItemsLength, 8), true);
      });

      test('login redirects to login page', () async {
        var loginBtn = await driver.findElement(
            const By.cssSelector('div.menu-item.menu-item--login > a'));
        await loginBtn.click();
        expect(await driver.currentUrl, endsWith('/login'));
      });
    });

    group("login and registration tests |", () {
      test('register a new user', () async {
        await driver.get(url);
        await waitForAngular(driver);
        await signUpNewRandomUser(driver, allUserPassword);
        await sleep10();
        var completedSignUp = await driver.findElement(const By.xpath(
            "*//input[contains(@value,'Megerősítő levél újraküldése')]"));
        await waitForAngular(driver);
        expect(await elementExists(completedSignUp), true);
      });

      test('login with a new user', () async {
        await loginUserWithCredentials(
            newUserEmail, allUserPassword, driver, true);
        await waitForAngular(driver);
        expect(await driver.currentUrl, contains('/probaidoszak'));
      });

      test('login with an old user', () async {
        await loginUserWithCredentials(
            oldUserEmail, allUserPassword, driver, false);
        await waitForAngular(driver);
        await sleep10();
        expect(await driver.currentUrl, contains('/profile'));
      });

      test('user is not logged in after logout', () async {
        await logoutUser(driver);
        await sleep2();
        await driver.get(url);
        await waitForAngular(driver);
        expect(await isLoggedIn(driver), false);
      });

      test('there is a profile img after login', () async {
        await loginUserWithCredentials(
            oldUserEmail, allUserPassword, driver, true);
        await waitForAngular(driver);
        expect(await isLoggedIn(driver), true);
      });
    });

    group("szolgaltatasaink menu tests |", () {
      setUpAll(() async {
        await loginUserWithCredentials(
            newUserEmail, allUserPassword, driver, true);
        await waitForAngular(driver);
        var profileBtn = await driver.findElement(
            const By.xpath('*//div[contains(@class, "menu-item--profile")]/a'));
        await profileBtn.click();
        await waitForAngular(driver);
        await sleep2();
      });

      tearDownAll(() async {
        await logoutUser(driver);
      });

      test('at least 8 elements in szolgaltatasaink menu after login',
          () async {
        var servicesBtn = await driver.findElement(
            const By.cssSelector('div.menu-item.menu-item--services > a'));
        await servicesBtn.click();
        var menuItemsLength = await driver
            .findElements(const By.xpath(
                '*//div[contains(@class, "menu-item--services")]/div[contains('
                    '@class, "nav-menu")]/div[contains(@class, "menu-item")]'))
            .length;
        await waitForAngular(driver);
        expect(await isXAtLeastValueOfY(menuItemsLength, 8), true);
      });

      test('szolgaltatasaink menu has trial after login', () async {
        var trialPeriodItem = await driver.findElements(const By.xpath(
            '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
            '/a[contains(@href,"/profile/product/probaidoszak")]'));
        expect(futureElementExists(trialPeriodItem), true);
      });

      test('szolgaltatasaink menu has settings after login', () async {
        var settingsItem = await driver.findElements(const By.xpath(
            '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
            '/a[contains(@href,"/profile/settings")]'));
        expect(futureElementExists(settingsItem), true);
      });

      test('szolgaltatasaink menu has logout after login', () async {
        var logoutItem = await driver.findElements(const By.xpath(
            '*//div[contains(@class, "nav-menu")]/div[contains(@class, "menu-item")]'
            '/a/span/font/font[contains(text(),"egress")]'));
        expect(futureElementExists(logoutItem), true);
      });
    });

    group("probaidoszak page tests |", () {
      setUpAll(() async {
        await waitForAngular(driver);
        await loginUserWithCredentials(
            newUserEmail, allUserPassword, driver, true);
        await navigateToPage(driver, 'profile/product/probaidoszak');
        await waitForAngular(driver);
        await sleep5();
      });

      test('you see a bunch of videos showing up', () async {
        var videoItemsLength = await driver
            .findElements(const By.cssSelector(
                'video-summary-list > div.training-type-list > div '
                '> video-summary > div.video-summary'))
            .length;
        print("Video items found: " + videoItemsLength.toString());
        expect(await isXAtLeastValueOfY(videoItemsLength, 5), true);
      });

      test('video popup shows on page after clicking a video', () async {
        var firstVideoItem;
        firstVideoItem = await driver.findElement(const By.xpath(
            '*//video-summary-list/div[contains(@class, '
                '"training-type-list")]//video-summary[1]'));
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

      group("probaidoszak filter tests |", () {
        setUp(() async {
          await navigateToPage(driver, 'profile/product/probaidoszak');
          await waitForAngular(driver);
          await sleep5();
        });

        test('joga filter options work', () async {
          var workoutVarietyFilterDropdown = await driver.findElement(
              const By.xpath('*//tag-set-filter/material-dropdown-select/'
                  'dropdown-button/div/span[contains(text(), "Edz")]'));
          await workoutVarietyFilterDropdown.click();
          var jogaFilterOption = await driver.findElement(const By.xpath(
              '*//div[contains(@class, "options")]/div/material-select-'
                  'dropdown-item/span[contains(text(), "jóga")]'));
          await jogaFilterOption.click();
          await waitForAngular(driver);
          await sleep2();
          var filteredVideoItemsLength = await driver
              .findElements(const By.cssSelector(
                  'video-summary-list > div.training-type-list > div '
                  '> video-summary > div.video-summary'))
              .length;
          expect(await isXAtLeastValueOfY(filteredVideoItemsLength, 2), true);
        });

        test('time filter options work', () async {
          var timeFilterDropdown = await driver.findElement(
              const By.xpath('*//tag-set-filter/material-dropdown-select/'
                  'dropdown-button/div/span[contains(text(), "Hossz")]'));
          await timeFilterDropdown.click();
          var thirtyMinFilterOption = await driver.findElement(const By.xpath(
              '*//div[contains(@class, "options")]/div/material-select-'
                  'dropdown-item/span[contains(text(), "45 perc")]'));
          await thirtyMinFilterOption.click();
          await waitForAngular(driver);
          await sleep2();
          var filteredVideoItemsLength = await driver
              .findElements(const By.cssSelector(
                  'video-summary-list > div.training-type-list > div '
                  '> video-summary > div.video-summary'))
              .length;
          expect(await isXAtLeastValueOfY(filteredVideoItemsLength, 6), true);
        });

        test('text filter options work', () async {
          var textFilter = await driver.findElement(
              const By.xpath("*//input[contains(@class, 'search-input')]"));
          await textFilter.click();
          await textFilter.sendKeys("FORMATORNA");
          await waitForAngular(driver);
          await sleep2();
          var filteredVideoItemsLength = await driver
              .findElements(const By.cssSelector(
                  'video-summary-list > div.training-type-list > div '
                  '> video-summary > div.video-summary'))
              .length;
          expect(await isXAtLeastValueOfY(filteredVideoItemsLength, 2), true);
        });
      });
    });

    group("product page megvasarlom tests |", () {
      setUpAll(() async {
        await loginUserWithCredentials(
            newUserEmail, allUserPassword, driver, true);
        await waitForAngular(driver);
        await navigateToPage(driver, 'profile/product/probaidoszak');
        await waitForAngular(driver);
        await sleep5();
      });

      test('clicking on megvasarlom throws no errors | the gwl', () async {
        bool hasErrors = false;
        await clickMegvasarlom(
            driver, 'product/view/a-nagy-sulyrakezdo-program-kezdo-szint');
        hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
        expect(await hasErrors, false);
      });

      test('clicking on megvasarlom throws no errors | superhuman program',
          () async {
        bool hasErrors = false;
        await clickMegvasarlom(driver, 'product/view/szuperhas-program');
        hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
        expect(await hasErrors, false);
      });

      test('clicking on megvasarlom throws no errors | dancing mom',
            () async {
          bool hasErrors = false;
          await clickMegvasarlom(driver, 'product/view/tancolj-anyukam-program');
          hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
          expect(await hasErrors, false);
      });

      test('clicking on megvasarlom throws no errors | joga mania',
            () async {
          bool hasErrors = false;
          await clickMegvasarlom(driver, 'product/view/jogamania-program');
          hasErrors = await checkForConsoleErrors(driver, 'SEVERE');
          expect(await hasErrors, false);
      });
    });

    group("workouts page tests |", () {
      test('at least 6 video elements under workouts', () async {
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

    group("workouts page tests | formatorna light |", () {
      setUpAll(() async {
        await driver.get(url + "video/view/formatorna-light");
        await waitForAngular(driver);
        await sleep5();
      });

      test('at least 5 element rows under hol erheto el', () async {
        var videosLength = await driver
            .findElements(const By.xpath(
                '*//workout-video-list/table/tbody/tr/td[1]/tag-representation/span'))
            .length;
        await waitForAngular(driver);
        print("Available Programs: " + videosLength.toString());
        expect(await isXAtLeastValueOfY(videosLength, 5), true);
      });

      test('at least 1 videotar under hol erheto el', () async {
        var videotarOccurrences = await driver
            .findElements(const By.xpath(
                '*//workout-video-list/table/tbody/tr/td/a[contains(@href, "video")]'))
            .length;
        await waitForAngular(driver);
        print("Occurrences of videotar: " + videotarOccurrences.toString());
        expect(await isXAtLeastValueOfY(videotarOccurrences, 1), true);
      });

      test('content box on left of page has data next to labels', () async {
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
        expect(await isXAtLeastValueOfY(valuesLength, descLinesLength), true);
      });
    });

    group('scores page tests |', () {
      setUpAll(() async {
        await waitForAngular(driver);
        await loginUserWithCredentials(
            oldUserEmail, allUserPassword, driver, true);
        await waitForAngular(driver);
        await sleep2();
        await driver.get(url + "profile/scores");
        await waitForAngular(driver);
        await sleep2();
      });

      test('user shows on highscore lists after login', () async {
        var userScore =
            await driver.findElement(const By.xpath('*//scores-list/div'
                '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
        expect(await elementExists(userScore), true);
      });

      test('birth-List tab has data that includes users name', () async {
        var birthListTab = await driver.findElement(const By.xpath(
            '*//dumb-tab-panel/nav/a[contains(text(), "ranglista")]'));
        await birthListTab.click();
        var userScore =
            await driver.findElement(const By.xpath('*//scores-list/div'
                '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
        expect(await elementExists(userScore), true);
      });

      test('30 days tab has data that includes users name', () async {
        var thirtyDaysTab = await driver.findElement(const By.xpath(
            '*//dumb-tab-panel/nav/a[contains(text(), "napos")]'));
        await thirtyDaysTab.click();
        var userScore =
            await driver.findElement(const By.xpath('*//scores-list/div'
                '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
        expect(await elementExists(userScore), true);
      });

      test('1 month ago tab has data that includes users name', () async {
        var oneMonthAgoTab = await driver.findElement(const By.xpath(
            '*//dumb-tab-panel/nav/a[contains(text(), "Velem egy")]'));
        await oneMonthAgoTab.click();
        var userScore =
            await driver.findElement(const By.xpath('*//scores-list/div'
                '/div[1]/div/ol/li/span[contains(text(), "connor")]'));
        expect(await elementExists(userScore), true);
      });
    });
  });
}