import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/splash/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/theme_selector/bloc/theme_mode_bloc.dart';
import 'package:user_repository/user_repository.dart';

/// The main application widget.
///
/// This widget is responsible for initializing and providing various
/// repositories and BLoCs to the rest of the application. It sets up
/// the [MultiRepositoryProvider] and [MultiBlocProvider], ensuring that
/// all dependencies are available throughout the app.
///
/// The root widget of the app is the [AppView] which is responsible for
/// setting up the [MaterialApp] with theming and the initial route.
class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required TeamsRepository teamsRepository,
    required AthletesRepository athletesRepository,
    required MedicalsRepository medicalsRepository,
    required PaymentsRepository paymentsRepository,
    required NotesRepository notesRepository,
    required DocumentsRepository documentsRepository,
    required User? user,
    super.key,
  })  : _userRepository = userRepository,
        _teamsRepository = teamsRepository,
        _athletesRepository = athletesRepository,
        _medicalsRepository = medicalsRepository,
        _paymentsRepository = paymentsRepository,
        _notesRepository = notesRepository,
        _documentsRepository = documentsRepository,
        _user = user;

  final UserRepository _userRepository;
  final TeamsRepository _teamsRepository;
  final MedicalsRepository _medicalsRepository;
  final AthletesRepository _athletesRepository;
  final PaymentsRepository _paymentsRepository;
  final NotesRepository _notesRepository;
  final DocumentsRepository _documentsRepository;
  final User? _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _teamsRepository),
        RepositoryProvider.value(value: _paymentsRepository),
        RepositoryProvider.value(value: _medicalsRepository),
        RepositoryProvider.value(value: _athletesRepository),
        RepositoryProvider.value(value: _notesRepository),
        RepositoryProvider.value(value: _documentsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              userRepository: _userRepository,
              user: _user,
            ),
          ),
          BlocProvider(create: (_) => ThemeModeBloc()),
        ],
        child: const AppView(),
      ),
    );
  }
}

/// The main view of the application.
///
/// This widget sets up the [MaterialApp] with the necessary theming
/// and initial route. It configures the theme, dark theme, and theme mode
/// for the app, and sets the initial screen to be the [SplashScreen].
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      home: const SplashScreen(),
    );
  }
}
