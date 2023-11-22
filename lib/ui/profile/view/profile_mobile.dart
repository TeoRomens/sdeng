import 'package:flutter/material.dart';
import 'package:sdeng/ui/profile/view/components/profile_col.dart';

class ProfileMobile extends StatelessWidget {
  const ProfileMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const ProfileColumn(),
            ),
          ),
        ),
      ),
    );
  }
}