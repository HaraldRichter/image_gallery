import 'package:universal_io/io.dart';
import 'package:bloc_tutorial_firebase/bloc/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_errors.dart';
import '../utils/upload_image.dart';
import 'app_events.dart';

/// This is the actual Bloc-Class. Here we handle all incoming Events and
/// emit the according States.

class AppBloc extends Bloc<AppEvent, AppState> {
  // Starting State: The first state is always "LoggedOut"
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    /// Initialize the Bloc:
    // At the start of the app, the user is always in the logged out-state. But
    // we want the Bloc to initialize and look if the user is actually logged in,
    // and if so, redirect him the the according screen.
    on<AppEventInitialize>(
      (event, emit) async {
        // Get the current user:
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // If not logged in, don't start loading and just stay on the Login-Screen:
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } else {
          // If the user is logged in, go grab the user's images and put the App
          // into the LoggedIn-State:
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(isLoading: false, user: user, images: images),
          );
        }
      },
    );

    /// Handle User Registration:
    on<AppEventRegister>((event, emit) async {
      // Start loading:
      emit(
        const AppStateIsInRegistrationView(isLoading: true),
      );
      final email = event.email;
      final password = event.password;
      try {
        // Create the user:
        final credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // Login the newly created user with an empty list of Images:
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    /// Handle User going from Login-Screen to Register-Screen:
    on<AppEventGoToRegistration>((event, emit) {
      // Here nothing really happens, the user is simply
      // redirected to the Registration-Screen, no loading or anything
      // else required (therefore this function also doesn't need to
      // be asynchronous).
      emit(
        const AppStateIsInRegistrationView(isLoading: false),
      );
    });

    /// Handle User going back from Register-Screen to Login-Screen:
    on<AppEventGoToLogin>((event, emit) {
      // The same applies here, just taking the User to the new Screen.
      emit(
        const AppStateLoggedOut(isLoading: false),
      );
    });

    /// Handle Login:
    on<AppEventLogIn>((event, emit) async {
      // If the user tries to login, we know his recent state is logged out,
      // so we start in the LoggedOut-State:
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // Now we log the user in:
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;
        // After we logged in the user, we need to get his images:
        final images = await _getImages(user.uid);
        // Finally update the UI with the new State:
        emit(
          AppStateLoggedIn(isLoading: false, user: user, images: images),
        );
        // Handle Exceptions:
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            // "You are still logged out, but you aren't loading anymore and
            // we might have an Error for you!"
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    /// Handle uploading Images:
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // "user" here is optional - we may or may not have a user.
        // We get the user with the help of the "getUser"-extension in AppState.
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
            // If you try to upload an image but aren't logged in, this
            // ensures you're in the LoggedOut-State.
          );
          return;
        }

        // Start the loading Process:
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
            // We get the images using the "getImages"-extension of AppState.
            // If we can't get images for any reason, we return an empty Iterable [].
          ),
        );

        // Upload an image:
        final file = File(event.filePathToUpload);
        await uploadImage(
          file: file,
          userId: user.uid,
        );
        // After the upload is complete, we have to grab the latest file references
        // so that everything is displayed correctly:
        final images = await _getImages(user.uid);
        // Emit the new images and turn off loading:
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );

    /// Handle Log out-Event:
    on<AppEventLogOut>(
      (event, emit) async {
        // Start loading
        emit(
          const AppStateLoggedOut(isLoading: true),
        );
        // Sign out on Firebase:
        await FirebaseAuth.instance.signOut();
        // Log out in the UI as well:
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      },
    );

    /// Handle Account Deletion:
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // Log the user out if we don't have a current User.
        // We can get the user either from state.user or directly
        // with FirebaseAuth, as we do here.
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        // If we have a user, the first thing we have to do is to start loading:
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );
        // Now we delete the user's folder inside Firebase Storage:
        try {
          // We iterate over all the items (= images) inside the user's Storage
          // Folder and delete them one at a time:
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {});
            // We just ignore errors here, which might not be best practice, but we
            // don't care for this tutorial project.
          }
          // Next: Delete the folder itself (I don't think this is even necessary, but well ...).
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});
          // Finally we actually delete the user account and sign the user out:
          await user.delete();
          await FirebaseAuth.instance.signOut();
          // Log the user out in the UI as well:
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          // Handle Exceptions:
        } on FirebaseAuthException catch (e) {
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          );
        } on FirebaseException {
          // We might not be able to delete the folder, just log the user out:
          const AppStateLoggedOut(
            isLoading: false,
          );
        }
      },
    );
  }

  // Function to get the Images from Firebase Storage so that they
  // are shown on the screen:
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
