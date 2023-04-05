import 'package:flutter/foundation.dart' show kDebugMode;

extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
  // With this, we can write Strings with the extension ".ifDebugging" so they are
  // shown only if the App is in Debug Mode, ie.:
  // void testIt() {
  //   'This is a String!'.ifDebugging;
  //   }
  // In this example the String appears only in Debug mode, otherwise it's just null.
}
