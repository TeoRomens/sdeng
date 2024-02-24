import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/tab_page.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/pages/login_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const RegisterPage(),
    );
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
    
    try {
      final repository = RepositoryProvider.of<Repository>(context);
      await repository.signup(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                    'REGISTER',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 75,
                        color: black2
                    )
                  ),
                  Text(
                    'Create a new account',
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
                      label: Text('example@email.com'),
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
                  spacer16,
                  SdengPrimaryButton(
                    text: 'REGISTER',
                    onPressed: _isLoading ? () {} : _signUp,
                  ),
                  spacer16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(LoginPage.route());
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
