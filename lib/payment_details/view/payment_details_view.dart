import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';

@visibleForTesting
class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({
    super.key,
    required this.payment
  });

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xlg - AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.xlg - AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Payment Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              CustomContainer(
                  icon: FeatherIcons.lock,
                  text: payment.id
              ),
              CustomContainer(
                  icon: FeatherIcons.alignLeft,
                  text: payment.cause
              ),
              CustomContainer(
                  icon: FeatherIcons.dollarSign,
                  text: payment.type == PaymentType.income
                      ? '+ ${payment.amount.toStringAsFixed(2)}' : '- ${payment.amount.toStringAsFixed(2)}'
              ),
              CustomContainer(
                  icon: FeatherIcons.calendar,
                  text: '${payment.createdAt.dMY}  ${payment.createdAt.hour}:${payment.createdAt.minute}:${payment.createdAt.second}'
              ),
              CustomContainer(
                  icon: payment.type == PaymentType.income
                    ? FeatherIcons.arrowDown : FeatherIcons.arrowUp,
                  text: payment.type.name
              ),
              CustomContainer(
                  icon: FeatherIcons.creditCard,
                  text: payment.method.name
              ),
              CustomContainer(
                  icon: FeatherIcons.user,
                  text: payment.athleteId ?? 'null'
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Profile',
        style: theme.textTheme.headlineLarge,
      ),
    );
  }
}
