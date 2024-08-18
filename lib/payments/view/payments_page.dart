import 'package:app_ui/app_ui.dart' show AppLogo;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payments/payments.dart';

/// A page displaying payments with different layouts for portrait and landscape orientations.
class PaymentsPage extends StatelessWidget {
  /// Creates an instance of [PaymentsPage].
  const PaymentsPage({super.key});

  /// Creates a route for the [PaymentsPage].
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
      )..getPayments(), // Fetch payments when the provider is created
      child: BlocListener<PaymentsCubit, PaymentsState>(
        listener: (context, state) {
          // Show an error message if the payments fetch fails
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
              // Display different views based on the orientation
              return orientation == Orientation.portrait
                  ? const PaymentsView()
                  : const PaymentsViewDesktop();
            },
          ),
        ),
      ),
    );
  }
}

