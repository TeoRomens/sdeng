import 'package:get/get.dart';
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
import 'package:sdeng/ui/add_athlete/view/add_athlete.dart';
import 'package:sdeng/ui/add_team/view/responsive.dart';
import 'package:sdeng/ui/athlete_details/view/responsive.dart';
import 'package:sdeng/ui/login/view/login.dart';
import 'package:sdeng/ui/med_visits/view/med_visits.dart';
import 'package:sdeng/ui/payments/view/payments.dart';
import 'package:sdeng/ui/profile/bloc/profile_bloc.dart';
import 'package:sdeng/ui/root/view/root_screen.dart';
import 'package:sdeng/ui/search/view/search.dart';
import 'package:sdeng/ui/settings/view/settings.dart';
import 'package:sdeng/ui/signup/view/signup.dart';

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
  //REPOs
  Get.put(AuthRepository());
  Get.put(TeamsRepository());
  Get.put(CalendarRepository());
  Get.put(AthletesRepository());
  Get.put(StorageRepository());
  Get.put(PaymentsRepository());
  Get.put(ParentsRepository());
  //BLOCs
  Get.put(ProfileBloc());
}

// GoRouter configuration
final _routes = [
  GetPage(
    name: '/',
    page: () => const RootScreen()
  ),
  GetPage(
      name: '/login',
      page: () => const Login()
  ),
  GetPage(
      name: '/signup',
      page: () => const Signup()
  ),
  GetPage(
      name: '/medVisits',
      page: () => const MedVisits()
  ),
  GetPage(
      name: '/payments',
      page: () => const Payments()
  ),
  GetPage(
      name: '/addTeam',
      page: () => const AddTeam()
  ),
  GetPage(
      name: '/addAthlete',
      page: () => AddAthlete()
  ),
  GetPage(
      name: '/search',
      page: () => const Search()
  ),
  GetPage(
      name: '/settings',
      page: () => const Settings()
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
            backgroundColor: const Color(0xff4D46B2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
            ),
          )
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          tileColor: const Color(0xffe7e6ff),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'ProductSans'
          )
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: const Color(0xffe8e8e8),
          collapsedBackgroundColor: const Color(0xffe8e8e8),
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
      initialRoute: '/login',
      getPages: _routes,
    );
  }
}

const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none
);