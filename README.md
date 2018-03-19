<h1 align="center">
  <img src="https://www.dartlang.org/assets/logo-61576b6c2423c80422c986036ead4a7fc64c70edd7639c6171eba19e992c87d9.svg" alt="Dart" width="400">
  <br>
  E2E Testing - Go Mummy Go
  <br>
</h1>


### Overview

Front end tests written in dart for [go mummy go](https://www.gyerunkanyukam.hu/). You will need to have the dart environment set up on your machine [Setting Up Dart](https://www.dartlang.org/install). You will also need to have Java installed [How to Install Java](https://docs.oracle.com/javase/7/docs/webnotes/install/windows/jdk-installation-windows.html) and the executable added to your system path in order to use [Selenium Webdriver](http://www.seleniumhq.org/download/) (selenium-server-standalone-3.6.0.jar is included in the project root). 

The tests will start selenium processes in the background and kill them at teardown - you may start selenium manually with the start_selenium.bat file in the project root. 

You may use taskkill to end all instances of selenium.
```bash
$ taskkill /im java.exe /f
```
Or run the kill_selenium.bat file in the project root which is also intended to do the same thing.


### Table of Contents

- [Quickstart](#quickstart)
- [Important Notes](#important-notes)
- [Running Tests](#running-tests)
- [Test Descriptions](#test-descriptions)
- [Directory And File Structure](#directory-and-file-structure)
- [Defining Dependencies](#defining-dependencies)
- [What is Dart?](#what-is-dart)
- [Additional Resources](#additional-resources)


### Quickstart

```bash
$ git clone https://github.com/con-king/E2E-Tests-Dart-Go-Mummy-Go.git
$ cd e2e-tests-dart-go-mummy-go
$ pub get
$ pub run test
```


### Important Notes


The credentials for testing login features are set in the main test file /test/frontend_test.dart

newUserEmail should point to the username email of a user still within the bounds of their trial (probe) period. Or some tests depending on the trial may fail.. See test descriptions below [Test Descriptions](#test-descriptions)

```dart
  var newUserEmail = "connor.stansfield.development@gmail.com";
  var oldUserEmail = "connor_stansfield@live.com";
  var allUserPassword = "password123%";
```


### Running Tests

All of the test files are located in the `test/` directory in the file frontend_test.dart. Tests are seperated into groups by similarity. See test descriptions below [Test Descriptions](#test-descriptions)

We can now run all unit tests using the following command:

```bash
$ pub run test
```

A single test file can be run just using:

```bash
$ pub run test path/to/frontend_test.dart.
```

You can select specific tests cases to run by name using:

```bash
$ pub run test -n "register a new user"
```

The string is interpreted as a regular expression, and only tests whose description (including any group descriptions) match that regular expression will be run. You can also use the -N flag to run tests whose names contain a plain-text string.


### Test Descriptions


Test #1: Loading the site returns valid content with 200 response code

Test #2: Check base url navigates to /home

Test #3: Check there is no error messages in the console

Test #4: Check at least 4 elements in the "Szolgaltatasok" menu

Test #5: Check "Szolgaltatasok" menu contains an instance of "Videotar

Test #6: Check login redirects to login page

Test #7: Register a new user

Test #8: Login with a new user

Test #9: Login with an old user

Test #10 User is not logged in by default

Test #11: Check there is a profile IMG after logging in

Test #12: Check you see at least 8 elements under Szolgáltatásaink menu

Test #13: After login, there is at least 8 elements in Szolgáltatásaink menu

Test #14: Check there is at least 6 video elements under /workouts

Test #15: Check at least 5 elements (rows) under "Hol érhet? el?"

Test #16: Check at least 1 "Videótár" under "Hol érhet? el?

Test #17: Box on left side of page has data not just labels

Test #18: Check you see a bunch of videos showing up

Test #19: Try to play the video, check if the popup shows up on page

Test #20: Check if the workout type filtering options work

Test #21: Check if the workout time filtering options work

Test #22: Check if the text filtering options work

Test #23: After login, Check user shows on all Highscore lists

Test #24 (Örökranglista): Scores Page Birth-List Tab has data and includes users name

Test #25 (30 napos): Scores Page 30-Days Tab has data and includes users name

Test #26 (egy hónapban): Scores Page 1-Month-Ago Tab has data and includes users name

Test #27: Check clicking on "Megvasarlom" throws no errors | The GWL

Test #28: Clicking on "Megvasarlom" throws no errors | Superhuman Program

Test #29: Clicking on "Megvasarlom" throws no errors | Dancing Mom

Test #30: Clicking on "Megvasarlom" throws no errors | Joga Mania



#### Directory And File Structure

Dart has a prescribed directory structure in order to ensure that its tools work
out of the box.

```
root/
 	libs/
 	test/
	tool/
	pubspec.lock
	pubspec.yaml
```

* **`lib/`**
  * Contains all internal implementation code.
* **`test/`**
  * Contains all unit, integration, and functional tests.
* **`pubspec.yaml`**
  * This file defines all the metadata about your package such as name, version, authors,
  dependencies, etc.
* **`pubspec.lock`**
  * This file specifies the version of each dependency installed in the project. 
  It will be automatically updated when dependencies change in
  `pubspec.yaml` or by running `pub upgrade`.```



#### Defining Dependencies

As previously mentioned, we'll use the `pubspec.yaml` file in our root directory to define the dependencies for our project. Let's take a look at the `pubspec.yaml` for the todo list.

**pubspec.yaml**
```yaml
name: frontend_tests

dev_dependencies:
  js: any
  webdriver: 1.2.2+1
  test:
  pageloader:
  random_string:
```

This file tells `pub` which versions of the included packages it needs to retrieve. You can find more information about what all can be included in this file [here](https://www.dartlang.org/tools/pub/pubspec).



### What is Dart?

Dart is a programming language originally [developed by Google](https://www.dartlang.org/) for building complex web applications. It's a statically-typed alternative to JavaScript that compiles to JS for use in the browser. It's open-source, easy to learn, and easy to scale. But wait, there's more!

- Strong IDE integration (code completion, code navigation, static analysis, etc.)
- Strong core set of common libraries (async, collections, isolates, etc.)
- Excellent development ecosystem
- Multi-threading support
- And [much, much more](https://www.dartlang.org/guides/language)

Google uses Dart for [AdWords](https://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html) which makes up the majority of Google's revenue. It's also the language we use at [Workiva](https://www.workiva.com/) for our next-generation products. Workiva has committed to using Dart and has published a [variety of OSS (open-source software) libraries](https://workiva.github.io/) to make developer's lives easier. If you're curious, here's a list of some companies [who use Dart.](https://www.dartlang.org/community/who-uses-dart) 

### Additional Resources

- [Intro to Dart for Java Developers](https://codelabs.developers.google.com/codelabs/from-java-to-dart/index.html#0)
- [Language Tour](https://www.dartlang.org/guides/language/language-tour)
- [Library Tour](https://www.dartlang.org/guides/libraries/library-tour)
- [Effective Dart](https://www.dartlang.org/guides/language/effective-dart)
- [Futures Tutorial](https://www.dartlang.org/tutorials/language/futures)
- [Streams Tutorial](https://www.dartlang.org/tutorials/language/streams)
- [Dart by Example](http://jpryan.me/dartbyexample/)
