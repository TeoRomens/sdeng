import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/ui/pages/tabs/athletes_tab.dart';
import 'package:sdeng/ui/pages/tabs/medical_tab.dart';
import 'package:sdeng/ui/pages/tabs/payments_tab.dart';
import 'package:sdeng/ui/pages/tabs/settings_page.dart';
import 'package:sdeng/utils/constants.dart';

/// Page that holds tab navigation at the bottom.
/// This is the first page presented to the user.
class TabPage extends StatefulWidget {
  /// Name of this page within `RouteSettings`
  static const name = 'TabPage';

  const TabPage({super.key});

  /// Method ot create this page with necessary `BlocProvider`
  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => const TabPage(),
    );
  }

  @override
  TabPageState createState() => TabPageState();
}

@visibleForTesting
/// State of `TabPage`. Made public for testing.
class TabPageState extends State<TabPage> {
  /// Currently shown tab index. Initially set to show the home.
  int _currentIndex = 0;

  List<IconData> listOfIcons = [
    FeatherIcons.home,
    FeatherIcons.file,
    FeatherIcons.dollarSign,
    FeatherIcons.user,
  ];

  List<String> listOfStrings = [
    'Home',
    'Medical',
    'Payments',
    'Account',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 14),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            AthletesTab.create(),
            MedicalTab.create(),
            PaymentsTab.create(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.width * .156,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                _currentIndex = index;
                HapticFeedback.lightImpact();
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2125,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == _currentIndex ? MediaQuery.of(context).size.width * .12 : 0,
                      width: index == _currentIndex ? MediaQuery.of(context).size.width * .2125 : 0,
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? Colors.grey.withOpacity(.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .2125,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        listOfIcons[index],
                        size: 22,
                        color: index == _currentIndex
                            ? Colors.black87
                            : Colors.black38,
                      ),
                      Text(
                          listOfStrings[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: index == _currentIndex
                              ? Colors.black87
                              : Colors.black38,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}