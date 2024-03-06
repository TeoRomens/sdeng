import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/login_page.dart';
import 'package:sdeng/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return SettingsPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            spacer16,
            Text('SETTINGS', style: GoogleFonts.bebasNeue(
                fontSize: 60,
                color: black2,
                height: 0.85
            )),
            spacer16,
            ListTile(
              title: const Text('Club'),
              leading: const Icon(FeatherIcons.shield, color: black2),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () {

              },
            ),
            spacer16,
            ListTile(
              title: const Text('General'),
              leading: const Icon(FeatherIcons.settings, color: black2),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () {

              },
            ),
            spacer16,
            ListTile(
              title: const Text('Account'),
              leading: const Icon(FeatherIcons.user, color: black2),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () {

              },
            ),
            spacer16,
            ListTile(
              title: const Text('Payments'),
              leading: const Icon(FeatherIcons.dollarSign, color: black2),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () {

              },
            ),
          ]
        ),
        spacer16,
        spacer16,
        ElevatedButton(
          onPressed: () async {
            await RepositoryProvider.of<Repository>(context).logout()
                .then((value) => Navigator.of(context)
                  .pushReplacement(LoginPage.route()));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(95, 44),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
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
    );
  }
}