/// Waits for Angular's tree to become stable (all change detection/update ran)

import 'dart:async';

import 'package:webdriver/io.dart';

WebDriver driver;

Future waitForAngular(WebDriver driver) {
  const _waitForTreeStability = '''
        var args = Array.from(arguments);
        var valueReporter = args.pop();
        window.getAllAngularTestabilities()[0].whenStable(function(){ 
          valueReporter(true);
        });        
    ''';
  return driver.executeAsync(_waitForTreeStability, []);
}

/// Executes `action` and waits for angular's tree to stabilize
/// Returns the actions return value
Future<T> angularCall<T>(Future<T> action()) async {
  var ret = await action();
  return waitForAngular(driver).then((_) => ret);
}

/// Waits for XHR requests sent via http.Client
Future<T> waitForXhrs<T>() async {
  const waitXhrs = '''
        var args = Array.from(arguments);
        var valueReporter = args.pop();
        window.krafty.xhr.whenDone(function() {
          valueReporter(true);
        });        
    ''';
  return driver.executeAsync(waitXhrs, []);
}
