import 'package:bloc_tutorial_firebase/dialogs/dialog_blueprint.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showLogoutDialog(BuildContext context) {
  return showBlueprintDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
  // Here we make the dialog optional. As the user can dismiss the dialog by tapping
  // anywhere on the screen, it's not sure that we get either true or false, but null.
}
