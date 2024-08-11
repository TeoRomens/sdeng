import 'package:athletes_repository/athletes_repository.dart';
import 'package:authentication_client/authentication_client.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:sdeng/app/view/app.dart';
import 'package:user_repository/user_repository.dart';

import 'bootstrap.dart';

/// The entry point of the application.
///
/// This function initializes the required repositories and services,
/// then passes them to the [App] widget, which is the root of the
/// Flutter application.
///
/// The [bootstrap] function is called with a builder function that
/// sets up various dependencies including repositories for handling
/// data related to users, teams, athletes, medicals, payments, notes,
/// and documents. The [PersistentStorage] is also initialized using
/// the provided [SharedPreferences] instance.
///
/// The [App] widget is then returned with all the necessary dependencies
/// passed to it.
void main() {
  bootstrap((
      sharedPreferences,
    ) async {
      // Initialize the API client for interacting with backend services.
      final apiClient = FlutterSdengApiClient();

      // Set up persistent storage using SharedPreferences.
      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

      // Initialize the authentication client.
      final authenticationClient = AuthenticationClient();

      // Set up the UserRepository with the authentication client and API client.
      final userRepository = UserRepository(
        authenticationClient: authenticationClient,
        apiClient: apiClient,
      );

      // Set up the TeamsRepository for managing team-related data.
      final teamsRepository = TeamsRepository(
        apiClient: apiClient,
      );

      // Set up the MedicalsRepository for managing medical records.
      final medicalsRepository = MedicalsRepository(
        apiClient: apiClient,
      );

      // Set up the PaymentsRepository for managing payment records.
      final paymentsRepository = PaymentsRepository(
        apiClient: apiClient,
      );

      // Set up the NotesRepository for managing notes.
      final notesRepository = NotesRepository(
        apiClient: apiClient,
      );

      // Set up the DocumentsRepository for managing documents.
      final documentsRepository = DocumentsRepository(
        apiClient: apiClient,
      );

      // Set up the AthletesRepository for managing athlete-related data.
      final athletesRepository = AthletesRepository(
        storage: AthletesStorage(storage: persistentStorage),
        apiClient: apiClient,
      );

      return App(
        userRepository: userRepository,
        teamsRepository: teamsRepository,
        athletesRepository: athletesRepository,
        medicalsRepository: medicalsRepository,
        paymentsRepository: paymentsRepository,
        notesRepository: notesRepository,
        documentsRepository: documentsRepository,
        user: await userRepository.user.first,
      );
    },
  );
}

