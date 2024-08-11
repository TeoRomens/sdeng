import 'package:app_ui/app_ui.dart' show AppLogo;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payments/payments.dart';
import 'package:sdeng/payments/view/payments_view_desktop.dart';

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
      child: BlocListener<PaymentsCubit, PaymentsState>(
        listener: (context, state) {
          if (state.status == PaymentsStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
          ),
          body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait
                ? const PaymentsView()
                : const PaymentsViewDesktop();
          }),
        ),
      ),
    );
  }
}
