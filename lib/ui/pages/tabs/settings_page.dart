import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/ui/pages/login_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return SettingsPage();
      },
    );
  }

  final Widget shimmer = Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: Container(
              height: 15,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 15,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                spacer16,
                spacer16,
                const Text('Settings', style: TextStyle(
                  fontSize: 26
                ),),
                spacer16,
                ListTile(
                  title: const Text('Club'),
                  leading: SvgPicture.asset('assets/icons/shield.svg'),
                  trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
                  tileColor: Colors.grey.shade200,
                  onTap: () {

                  },
                ),
                spacer16,
                spacer16,
              ]
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Fix logout
                Navigator.of(context).pushReplacement(LoginPage.route());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(95, 44),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                    fontFamily: 'ProductSans',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(child: Text('Logout'))
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}