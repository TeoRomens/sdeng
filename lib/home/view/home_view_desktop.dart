import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/medical/view/view.dart';
import 'package:sdeng/notes/view/notes_view.dart';
import 'package:sdeng/payments/payments.dart';
import 'package:sdeng/teams/view/teams_view_desktop.dart';
import 'package:sdeng/settings/widgets/user_profile_button.dart';

class HomeViewDesktop extends StatefulWidget {
  const HomeViewDesktop({super.key});

  @override
  State<HomeViewDesktop> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeViewDesktop> {
  final pageController = PageController();
  int selectedPageIndex = 1;

  List<IconData> listOfIcons = [
    FeatherIcons.home,
    FeatherIcons.filePlus,
    FeatherIcons.dollarSign,
    FeatherIcons.edit3,
  ];

  List<String> listOfStrings = [
    'Home',
    'Medical',
    'Payments',
    'Notes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
        actions: const [UserProfileButton()],
      ),
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: listOfStrings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppSpacing.xs,
                    left: AppSpacing.xs,
                    bottom: AppSpacing.xs
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(
                      right: AppSpacing.sm,
                      left: AppSpacing.lg
                    ),
                    horizontalTitleGap: 8,
                    selected: selectedPageIndex == index,
                    visualDensity: VisualDensity.compact,
                    tileColor: AppColors.brightGrey,
                    selectedTileColor: AppColors.primary,
                    iconColor: AppColors.black,
                    textColor: AppColors.black,
                    selectedColor: AppColors.white,
                    leading: Icon(listOfIcons[index]),
                    title: Text(listOfStrings[index], style: UITextStyle.headlineSmall,),
                    onTap: () {
                      setState(() {
                        selectedPageIndex = index;
                      });
                      pageController.jumpToPage(index);
                    }
                  ),
                );
              }
            )
          ),
          const VerticalDivider(width: 0, indent: 0,),
          Flexible(
            flex: 5,
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                TeamsViewDesktop(),
                MedicalView(),
                PaymentsView(),
                NotesView(),
              ],
            ),
          )
        ]
      ),
    );
  }
}
