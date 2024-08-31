import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';

/// A view for selecting a payment formula from a list.
///
/// This widget displays a list of payment formulas retrieved from the repository.
/// It shows a loading indicator while fetching data and provides options to select a formula or close the view.
class PaymentFormulaListView extends StatefulWidget {
  /// Creates an instance of [PaymentFormulaListView].
  const PaymentFormulaListView({super.key});

  @override
  State<PaymentFormulaListView> createState() => _PaymentFormulaListViewState();
}

class _PaymentFormulaListViewState extends State<PaymentFormulaListView> {
  List<PaymentFormula> _paymentFormulas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchFormulas();
  }

  /// Fetches the list of payment formulas from the repository.
  Future<void> fetchFormulas() async {
    try {
      final formulas = await context.read<PaymentsRepository>().getPaymentFormulas();
      setState(() {
        _paymentFormulas = formulas;
        _loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Error loading formulas.'),
          ),
        );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: const Text('Select Formula'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Expanded(
            child: _loading
              ? const LoadingBox()
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_paymentFormulas.isEmpty)
                      EmptyState(
                        showAction: false,
                        actionText: '',
                        onPressed: () {})
                    else
                      Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.xs,
                            ),
                            title: const Text('None'),
                            titleTextStyle: Theme.of(context).textTheme
                                .headlineSmall?.copyWith(fontSize: 19),
                            subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
                            trailing: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(FeatherIcons.chevronRight),
                            ),
                            onTap: () => Navigator.of(context).pop(null),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: _paymentFormulas.length,
                            itemBuilder: (context, index) {
                              return PaymentFormulaTile(
                                paymentFormula: _paymentFormulas[index],
                                onTap: () => Navigator.of(context).pop(_paymentFormulas[index].id),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                            const Divider(height: 0, indent: 70, endIndent: 20),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}
