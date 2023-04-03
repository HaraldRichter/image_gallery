import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../auth/auth_errors.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  // [isLoading] is defined as an overall property, because every Screen/Action
  // may need some time to load. We define it here, so we don't have to define it
  // in each and every subclass later on. And second - more important - this way we
  // have one place inside the entire application that takes care of the loading screen.
  final AuthError? authError;
  // [AuthError] is defined in the Superclass, because at least two subclasses can have
  // and AuthError in them. This way we don't have to define it for each of these classes
  // separately.

  const AppState({
    required this.isLoading,
    required this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  // [Iterable<References> images] gets the images from Firebase Storage.
  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.images,
    required AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  bool operator ==(other) {
    // The equality-check makes sure that changes that don't effect the overall state
    // still get registered and processed by the bloc. Concrete: If a user uploads or deletes
    // an image, the App stays in the "LoggedIn"-State, but obviously something happened. So
    // we make a comparison to check if something happened or not. This goes for all classes of the app.
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  // TODO: Nachschauen, was zur Hölle es damit auf sich hat
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
  // The "toString"-Method is used for poor men's debugging (like printing out shit like a total noob)
  // and also for Bloc Tests.
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    required AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    required AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

/// Following some helpers:

extension GetUser on AppState {
  // This helper-class enables us to get the user-data from any AppState.
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  // This helper-class enables us to get the images-data from any AppState.
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
