import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/splash_page.dart';
import 'package:sdeng/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _supabase = Supabase.instance.client;
  final _localStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>(
          create: (context) => Repository(
            supabaseClient: _supabase,
            localStorage: _localStorage,
          ),
        ),
      ],
      // TODO: Add MultiBlocProvider with NotificationCubit here
      child: MaterialApp(
        theme: themeData,
        darkTheme: themeData,
        home: const SplashPage(),
      ),
    );
  }
}