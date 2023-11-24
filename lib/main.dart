import 'package:bot_toast/bot_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:sdeng/firebase_options.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/calendar_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/ui/login/view/login.dart';
import 'package:sdeng/ui/root/view/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Sdeng',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  injectDependencies();
  runApp(const MyApp());
}

void injectDependencies() {
  final getIt = GetIt.I;
  getIt.registerSingleton<AuthRepository>(AuthRepository());
  getIt.registerSingleton<TeamsRepository>(TeamsRepository());
  getIt.registerSingleton<CalendarRepository>(CalendarRepository());
  getIt.registerSingleton<AthletesRepository>(AthletesRepository());
  getIt.registerSingleton<StorageRepository>(StorageRepository());
  getIt.registerSingleton<PaymentsRepository>(PaymentsRepository());
  getIt.registerSingleton<ParentsRepository>(ParentsRepository());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const RootScreen(),
    ),
  ],
  observers: [BotToastNavigatorObserver()],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Sdeng',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ProductSans',
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: Colors.black
          )
        ),
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffE7E6FF),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xff4D46B2),
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(
              color: Color(0xff4D46B2),
            ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 236, 236, 236),
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 174, 174, 174),
          ),
          labelStyle: TextStyle(
              color: Colors.black
          ),
          border: defaultOutlineInputBorder,
          enabledBorder: defaultOutlineInputBorder,
          focusedBorder: defaultOutlineInputBorder,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade400,
          selectedColor: Colors.green.shade400,
          showCheckmark: false,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'ProductSans',
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            minimumSize: const Size(100, 52),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
              fontFamily: 'ProductSans',
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'ProductSans',
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xff4D46B2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
            ),
          )
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          tileColor: Color(0xffe7e6ff),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'ProductSans'
          )
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Color(0xffe8e8e8),
          collapsedBackgroundColor: Color(0xffe8e8e8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          iconColor: Colors.black,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                )
            )
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xffe7e6ff),
          shape: CircleBorder(side: BorderSide.none),
            foregroundColor: Color(0xff4D46B2)
        ),
        colorScheme: ColorScheme.light(
          primary: MyColors.primaryColor,
        )
      ),
      builder: BotToastInit(),
    );
  }
}

const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none
);