import 'package:bloc_tutorial_firebase/dialogs/dialog_blueprint.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showBlueprintDialog<bool>(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure you want to delete your account? You cannot undo this operation and all your images will be lost forever!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  ).then((value) => value ?? false);
  // Here we make the dialog optional. As the user can dismiss the dialog by tapping
  // anywhere on the screen, it's not sure that we get either true or false, but null.
}
