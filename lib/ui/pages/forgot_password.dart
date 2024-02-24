import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/tab_page.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/pages/register_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/res_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  /// Name of this page within `RouteSettings`
  static const name = 'ForgotPasswordPage';

  static Route<void> route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: name),
        builder: (context) => const ForgotPasswordPage()
    );
  }

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

@visibleForTesting
/// State of `ForgotPasswordPage`. Made public for testing.
class ForgotPasswordPageState extends State<ForgotPasswordPage> {

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  Future<void> _forgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = RepositoryProvider.of<Repository>(context);
      await repository.forgotPassword(
          email: _emailController.text,
      );
    } on AuthException catch (err) {
      if(mounted) {
        context.showErrorSnackBar(message: err.message);
      }
    } catch (err) {
      if(mounted) {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ResponsiveWidget(
            mobile: loginMobile(),
            desktop: loginDesktop(),
          ),
        )
    );
  }

  Widget loginDesktop() {
    final resHelper = ResponsiveHelper(context: context);

    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(left: resHelper.deviceSize.width / 20),
              child: SvgPicture.asset(
                'assets/logos/SDENG_logo.svg',
                width: resHelper.deviceSize.width / 3,
                color: const Color(0xff4D46B2),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: formPadding,
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700
                      ),
                    ),
                    spacer16,
                    spacer16,
                    spacer16,
                    SdengDefaultButton(
                        text: 'Continue with Google',
                        icon: SvgPicture.asset('assets/logos/Google.svg'),
                        onPressed: () {

                        }
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xff686f75),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text('mariorossi@mail.com'),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    spacer16,
                    spacer16,
                    SdengPrimaryButton(
                      text: 'Sign In',
                      onPressed: _isLoading ? () {} : _forgotPassword,
                    ),
                    spacer16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?  '),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(RegisterPage.route());
                          },
                          child: const Text('Sign Up Now'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginMobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            spacer16,
            SvgPicture.asset(
              'assets/logos/SDENG_logo.svg',
              height: 20,
              alignment: Alignment.topLeft
            ),
            spacer16,
            spacer16,
            Text(
              'FORGOT\nPASSWORD',
              style: GoogleFonts.bebasNeue(
                fontSize: 75,
                color: black2,
                height: 1
              )
            ),
            spacer16,
            spacer16,
            spacer16,
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Email',
                style: TextStyle(
                  color: Color(0xff686f75),
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('example@email.com'),
                prefixIcon: Icon(
                  FeatherIcons.mail,
                  color: black1,
                  size: 22,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            spacer16,
            SdengPrimaryButton(
              text: 'SUBMIT',
              onPressed: _isLoading ? () {} : _forgotPassword,
            ),
            spacer16,
          ],
        ),
      ),
    );
  }
}