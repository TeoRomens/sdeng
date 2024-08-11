import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Type definition for the app builder function.
///
/// This function returns a [Future] that resolves to a [Widget],
/// which is the root of the Flutter app. The [SharedPreferences]
/// instance is provided to the builder for persistent storage access.
typedef AppBuilder = Future<Widget> Function(
    SharedPreferences sharedPreferences,
    );

/// Initializes the app with necessary configurations and runs the [builder] function.
///
/// This function performs the following:
///
/// 1. Ensures Flutter bindings are initialized.
/// 2. Loads environment variables from a `.env` file.
/// 3. Initializes Supabase with the provided configurations.
/// 4. Configures `HydratedBloc` with a storage directory and clears it if in debug mode.
/// 5. Sets up a global error handler to log Flutter errors.
/// 6. Retrieves an instance of [SharedPreferences] and passes it to the [builder] function.
/// 7. Runs the app by calling [runApp] with the [Widget] returned from the [builder].
///
Future<void> bootstrap(AppBuilder builder) async {
  // Ensure Flutter widget binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file.
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with configuration settings.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'SUPABASE_URL',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'SUPABASE_ANON_KEY',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );

  // Configure HydratedBloc with the storage directory.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  // Clear the storage if in debug mode.
  if (kDebugMode) {
    await HydratedBloc.storage.clear();
  }

  // Set up global error handling to log Flutter errors.
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Get an instance of SharedPreferences.
  final sharedPreferences = await SharedPreferences.getInstance();

  // Run the app by invoking the builder and passing the SharedPreferences instance.
  runApp(await builder(sharedPreferences));
}

