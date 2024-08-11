import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';

class PaymentFormulaListView extends StatefulWidget {
  const PaymentFormulaListView({
    super.key,
  });

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

  Future<void> fetchFormulas() async {
    _paymentFormulas = await context.read<PaymentsRepository>().getPaymentFormulas();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: const Text('Select formula'),
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
                : FormulasPopulated(paymentFormulas: _paymentFormulas),
          ),
        ],
      ),
    );
  }
}

/// Main view of Payment Formulas.
@visibleForTesting
class FormulasPopulated extends StatelessWidget {
  const FormulasPopulated({
    super.key,
    required this.paymentFormulas,
  });

  final List<PaymentFormula> paymentFormulas;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paymentFormulas.isEmpty)
            const Center(
              heightFactor: 5,
              child: Text('It seems empty here'),
            )
          else
            Column(
              children: [
                ListTile(
                  visualDensity: const VisualDensity(
                    vertical: VisualDensity.minimumDensity,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  title: Text('None'),
                  titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 19
                  ),
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
                  itemCount: paymentFormulas.length,
                  itemBuilder: (context, index) {
                    return PaymentFormulaTile(
                      paymentFormula: paymentFormulas[index],
                      onTap: () => Navigator.of(context).pop(paymentFormulas[index].id),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 0, indent: 70, endIndent: 20),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
