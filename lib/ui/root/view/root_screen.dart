import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/dimension.dart';
import 'package:sdeng/ui/calendar/view/calendar_screen.dart';
import 'package:sdeng/ui/homepage_staff/view/homepage_staff.dart';
import 'package:sdeng/ui/profile/view/profile.dart';
import 'package:sdeng/ui/reports/view/events_desktop.dart';
import 'package:sdeng/ui/homepage_staff/view/home_staff_desktop.dart';
import 'package:sdeng/ui/homepage_staff/view/home_staff_mobile.dart';
import 'package:sdeng/ui/reports/view/events_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });

  static Route route(BuildContext context) =>
      MaterialPageRoute(
        builder: (_) => const RootScreen(),
    );

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final resHelper = ResponsiveHelper(context: context);
    List<IconData> listOfIcons = [
      Icons.home_rounded,
      Icons.calendar_month_rounded,
      Icons.table_rows_rounded,
      Icons.person_rounded,
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if(constraints.maxWidth < WIDTH_MOBILE) {
          return Scaffold(
            appBar: AppBar(
              title: SvgPicture.asset(
                'assets/logos/SDENG_logo.svg',
                height: 25,
              )
            ),
            bottomNavigationBar: Transform.scale(
              scale: resHelper.deviceSize.width > 400 ? 400 / resHelper.deviceSize.width : 1,
              child: Container(
                height: resHelper.deviceSize.width * .155,
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                  padding: EdgeInsets.symmetric(horizontal: resHelper.deviceSize.width * .027),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                        HapticFeedback.lightImpact();
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: resHelper.deviceSize.width * .2125,
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              height: currentIndex == index ? resHelper.deviceSize.width * .12 : 0,
                              width: currentIndex == index ? resHelper.deviceSize.width * .2125 : 0,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? const Color(0xffE7E6FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: resHelper.deviceSize.width * .2125,
                          alignment: Alignment.center,
                          child: Icon(
                            listOfIcons[index],
                            size: resHelper.deviceSize.width * .076,
                            color: currentIndex == index
                                ? MyColors.primaryColorDark
                                : Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
                builder: (context) {
                  switch(currentIndex){
                    case 0: return const HomepageStaff();
                    case 1: return const CalendarPage();
                    case 2: return const EventsMobile();
                    case 3: return const Profile();
                    default: return const HomeStaffMobile();
                  }
                }
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: SvgPicture.asset(
                'assets/logos/SDENG_logo.svg',
                height: 25,
              )
            ),
            body: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16, right: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            tileColor: MyColors.primaryColorLighter,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            title: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColorDark,
                              ),
                              maxLines: 1,
                            ),
                            leading: const Icon(Icons.home_rounded),
                            horizontalTitleGap: 10,
                            onTap: () => setState(() {
                              currentIndex = 0;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            tileColor: MyColors.primaryColorLighter,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            title: Text(
                              'Calendar',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColorDark,
                              ),
                              maxLines: 1,
                            ),
                            leading: const Icon(Icons.calendar_month_rounded),
                            horizontalTitleGap: 10,
                            onTap: () => setState(() {
                              currentIndex = 1;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            tileColor: MyColors.primaryColorLighter,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            title: Text(
                              'Reports',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColorDark,
                              ),
                              maxLines: 1,
                            ),
                            leading: const Icon(Icons.table_rows),
                            horizontalTitleGap: 10,
                            onTap: () => setState(() {
                              currentIndex = 2;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            tileColor: MyColors.primaryColorLighter,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            title: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryColorDark,
                              ),
                              maxLines: 1,
                            ),
                            leading: const Icon(Icons.settings),
                            horizontalTitleGap: 10,
                            onTap: () => setState(() {
                              currentIndex = 3;
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Builder(
                      builder: (context) {
                        switch(currentIndex){
                          case 0: return const HomepageStaff();
                          case 1: return const CalendarPage();
                          case 2: return const EventsDesktop();
                          case 3: return const Profile();
                          default: return const HomeStaffDesktop();
                        }
                      }
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

