import 'package:universal_io/io.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<bool> uploadImage({
  // Future-bool because it returns true or false, depending if the upload
  // was successful or failed.
  required File file,
  required String userId,
}) =>
    FirebaseStorage.instance
        // Get the User-id:
        .ref(userId)
        // Create a File ("child") with random name inside Firebase Storage:
        .child(const Uuid().v4())
        // Upload our file into the newly created Child:
        .putFile(file)
        // If upload is successful, return true:
        .then((_) => true)
        // If something goes wrong, catch Error and return false:
        .catchError((_) => false);
