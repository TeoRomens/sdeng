import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';
import 'package:sdeng/util/text_util.dart';
import 'package:sdeng/util/ui_utils.dart';

class SettingsForm extends StatefulWidget{
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();

    return Column(
      children: [
        ExpansionTile(
          leading: const Icon(Icons.edit_calendar),
          title: const Text(
            'Calendar Id',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'New calendar id',
                  suffixIcon: IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.check)
                  )
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        ExpansionTile(
          leading: const Icon(Icons.euro_symbol_rounded),
          title: const Text(
            'Quota Under',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.normal
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'New Quota Under',
                  suffixIcon: IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.check)
                  )
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        ExpansionTile(
          leading: const Icon(Icons.euro_symbol_rounded),
          title: const Text(
            'Quota Minibasket',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'New Quota Minibasket',
                  suffixIcon: IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.check)
                    ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.edit),
            trailing: Text(TextUtils.toHumanReadable(Variables.firstPaymentDate)),
            title: const Text(
              'Last Date First Payment',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),
            ),
            onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if(selectedDate != null) {
                  UIUtils.awaitLoading(bloc.payDate1Changed(selectedDate));
                }
              }
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.edit),
            trailing: Text(TextUtils.toHumanReadable(Variables.secondPaymentDate)),
            title: const Text(
              'Last Date Second Payment',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),
            ),
            onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if(selectedDate != null) {
                  UIUtils.awaitLoading(bloc.payDate2Changed(selectedDate));
                }
              }
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.edit),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            title: const Text(
              'Society Preferences',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),
            ),
            onTap: () {

            }
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.fingerprint),
            trailing: Switch(
              value: bloc.state.biometrics,
              onChanged: (bool value) => setState(() {
                context.read<SettingsBloc>().setBiometrics(value);
              })
            ),
            title: const Text(
              'Login with Biometrics',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),
            ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}