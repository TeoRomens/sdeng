import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/forgot_password.dart';
import 'package:sdeng/ui/pages/tab_page.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/pages/register_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/res_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  /// Name of this page within `RouteSettings`
  static const name = 'LoginPage';

  static Route<void> route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: name),
        builder: (context) => const LoginPage()
    );
  }

  @override
  State<LoginPage> createState() => LoginPageState();
}

@visibleForTesting
/// State of `LoginPage`. Made public for testing.
class LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _remember = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = RepositoryProvider.of<Repository>(context);
      await repository.login(
          email: _emailController.text,
          password: _passwordController.text
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
  void initState() {
    _setupAuthListener();
    _checkTermsOfServiceAgreement();
    super.initState();
  }

  void _setupAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(TabPage.route());
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkTermsOfServiceAgreement() async {
    final agreed = await RepositoryProvider.of<Repository>(context)
        .hasAgreedToTermsOfService;
    if (!agreed) {
      setState(() {
        // TODO: Implement error message in this case
        context.showErrorSnackBar(message: 'You must accept the terms of service.');
      });
    }
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
            child: Center(
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Color(0xff686f75),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('••••••'),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Required';
                          }
                          if (val.length < 6) {
                            return '6 characters minimum';
                          }
                          return null;
                        },
                      ),
                      spacer16,
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            onChanged: (value) => setState(() {
                              _remember = !_remember;
                            }),
                          ),
                          const Text('Remember Me',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      spacer16,
                      SdengPrimaryButton(
                        text: 'Sign In',
                        onPressed: _isLoading ? () {} : _login,
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
          ),
        ],
      ),
    );
  }

  Widget loginMobile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: formPadding,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SvgPicture.asset(
                'assets/logos/SDENG_logo.svg',
                height: 20,
                alignment: Alignment.topLeft
              ),
              spacer16,
              Text(
                'LOGIN',
                style: GoogleFonts.bebasNeue(
                  fontSize: 75,
                  color: black2
                )
              ),
              Text(
                'Sign in to your existing account',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500
                ),
              ),
              spacer16,
              spacer16,
              spacer16,
              SdengDefaultButton(
                  text: 'Continue with Google',
                  icon: SvgPicture.asset('assets/logos/Google.svg'),
                  onPressed: () async {
                    await RepositoryProvider.of<Repository>(context).googleLogin();
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
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Color(0xff686f75),
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('••••••'),
                  prefixIcon: Icon(
                    FeatherIcons.lock,
                    color: black1,
                    size: 22,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  if (val.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),
              spacer16,
              spacer16,
              SdengPrimaryButton(
                text: 'LOGIN',
                onPressed: _isLoading ? () {} : _login,
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
                    child: const Text('Register'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(ForgotPasswordPage.route());
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}