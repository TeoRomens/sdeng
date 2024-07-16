import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payments/cubit/payments_cubit.dart';
import 'package:sdeng/payments/payments.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/teams_view_desktop.dart';
import 'package:teams_repository/teams_repository.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const PaymentsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentsCubit(
        paymentsRepository: context.read<PaymentsRepository>(),
      )..getPayments(),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait ?
                const PaymentsView() : const PaymentsView();
          }
      ),
    );
  }
}
