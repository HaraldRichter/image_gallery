import 'package:flutter/foundation.dart' show immutable;

// Events normally don't have any further logic, they shouldn't be mutating,
// because you just want to have the events passed to the bloc and nothing else;
// otherwise weird shit may happen, so it's important to keep the events immutable.

/// First we create and abstract class "AppEvent":
@immutable
abstract class AppEvent {
  const AppEvent();
}

/// Then we create the individual events as implementations of AppEvent:
@immutable
class AppEventInitialize implements AppEvent {
  // Bloc HAS to have an initializer!
  const AppEventInitialize();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventLogIn implements AppEvent {
  final String email;
  final String password;

  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoToRegistration implements AppEvent {
  // If the user clicks on "register", he is directed to the registration
  // view with this event.
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  // If the user is on the "register"-view, he can get back to the login-screen.
  const AppEventGoToLogin();
}
