import 'package:bloc_tutorial_firebase/loading/loading_screen.dart';
import 'package:bloc_tutorial_firebase/views/login_view.dart';
import 'package:bloc_tutorial_firebase/views/photo_gallery_view.dart';
import 'package:bloc_tutorial_firebase/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_events.dart';
import '../bloc/app_state.dart';
import '../dialogs/show_auth_error.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      // The whole App is wrapped within the Bloc Provider.
      create: (_) => AppBloc()
        // AppBloc starts out with the "LoggedOuState" ...
        ..add(
          const AppEventInitialize(),
          // ...and then we send the Event "Initialize".
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          // A Bloc Consumer is like kind of a mixture of a BlocListener and a
          // BlocBuilder. The Listener is doing some side effects while the Builder
          // is actually building Widgets and stuff.
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // Thanks to Bloc Listener we can handle every possible type of Error in only
            // one single place. We don't even have to await anything, as the Errors don't
            // return any value.
            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
              // This should actually never happen.
            }
          },
        ),
      ),
    );
  }
}
