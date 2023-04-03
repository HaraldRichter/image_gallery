import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

/// Unser Ziel ist es, mit dem Bloc nicht unmittelbar die Fehlermeldungen von
/// Firestore zu reproduzieren, sondern diese in lokale Fehlermeldungen "umzuwandeln",
/// mit denen dann unser Bloc arbeiten kann.
/// An overview of possible Firebase Authentication Errors is available at:
/// https://firebase.google.com/docs/auth/admin/errors

// This Map is matches the firebase auth error, which is delivered as a String,
// with the according instance of AuthError.
// Using Mapping we avoid having to write a convoluted if-statement.
const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-exists': AuthErrorEmailAlreadyExists(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  // Every error shall be displayed as a dialog box.
  // Here we have kind of the blueprint for these boxes; using this
  // blueprint, we create a shitload of instances of the AuthError-class,
  // one für each possible firebase auth error.
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      // Here the actual mapping takes place, using the [exception.code] as key.
      // If the actual error can't be found within our map, throw AuthErrorUnknown.
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

/// Follows the list of the specific instances of AuthError:

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Authentication error',
          dialogText: 'Unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  // auth/no-current-user:
  // If you try to delete a non-existing user for whatever strange reasons...
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user!',
          dialogText: 'No current user with this information was found!',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  // auth/requires-recent-login:
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogText:
              'You need to log out and log back in again in order to perform this operation.',
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  // auth/operation-not-allowed:
  // The provided sign-in provider is disabled for your Firebase project.
  // Enable it from the Sign-in Method section of the Firebase console.
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: 'Operation not allowed',
          dialogText: 'You cannot register using this method at this moment!',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  // auth/user-not-found:
  // There is no existing user record corresponding to the provided identifier.
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'The given user was not found on the server!',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  // auth/weak-password:
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogText:
              'Your password does not match the requirements for security. Please choose a stronger password with at least six characters!',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  // auth/invalid-email:
  // The provided value for the email user property is invalid. It must be a string email address.
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogText: 'Please double-check your email and try again!',
        );
}

@immutable
class AuthErrorEmailAlreadyExists extends AuthError {
  // auth/email-already-exists:
  // The provided email is already in use by an existing user. Each user must have a unique email.
  const AuthErrorEmailAlreadyExists()
      : super(
          dialogTitle: 'Invalid email',
          dialogText:
              'The provided email is already in use by an existing user. Please choose another email.',
        );
}
