import 'package:bloc_tutorial_firebase/auth/auth_errors.dart';
import 'package:bloc_tutorial_firebase/dialogs/dialog_blueprint.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthErrorDialog(
    {required AuthError authError, required BuildContext context}) {
  return showBlueprintDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
      // This dialog doesn't really have any function and returns nothing,
      // it's just to inform the user.
    },
  );
}
