import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/ui/login/bloc/login_bloc.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:sdeng/util/res_helper.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.formKey,});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final resHelper = ResponsiveHelper(context: context);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) => context.read<LoginBloc>().emailChanged(value),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  onChanged: (value) => context.read<LoginBloc>().passwordChanged(value),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 10.0),
                CheckboxListTile(
                  tileColor: Colors.transparent,
                  activeColor: const Color(0xff4D46B2),
                  value: state.rememberme,
                  onChanged: (value) => context.read<LoginBloc>().rememberme(value!),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  title: const Text(
                    "Remember Me",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    if(formKey.currentState!.validate()) {
                      UIUtils.awaitLoading(context.read<LoginBloc>().login());
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Divider(
                  indent: resHelper.deviceSize.width / 6,
                  endIndent: resHelper.deviceSize.width / 6,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => context.read<LoginBloc>().login(LoginProvider.google),
                        style: IconButton.styleFrom(
                          fixedSize: const Size(80, 80),
                        ),
                        icon: SvgPicture.asset('assets/icons/google.svg')
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white
                  ),
                  onPressed: () => Get.toNamed('/signup'),
                  child: Text('Create Account', style: TextStyle(
                    color: MyColors.primaryColorDark,

                  ),),
                ),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        );
      }
    );
  }
}