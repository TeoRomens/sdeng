import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formulas_list/payment_formulas_list.dart';

class PaymentFormulaListView extends StatefulWidget {
  const PaymentFormulaListView({
    super.key,
  });

  static Route<PaymentFormula> route() {
    return MaterialPageRoute<PaymentFormula>(
      builder: (_) => const PaymentFormulaListView(),
    );
  }

  @override
  State<PaymentFormulaListView> createState() => _PaymentFormulaListViewState();
}

class _PaymentFormulaListViewState extends State<PaymentFormulaListView> {
  List<PaymentFormula> _paymentFormulas = [];
  bool _loading = true;

  @override
  void initState() {
    fetchAthletes();
    super.initState();
  }

  Future<void> fetchAthletes() async {
    _paymentFormulas = await context.read<PaymentsRepository>().getPaymentFormulas();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select formula'),
      ),
      body: _loading
        ? const LoadingBox()
        : FormulasPopulated(paymentFormulas: _paymentFormulas,)
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class FormulasPopulated extends StatefulWidget {
  /// Main view of Athletes.
  FormulasPopulated({
    super.key,
    List<PaymentFormula>? paymentFormulas,
  })  : _paymentFormulas = paymentFormulas ?? [];

  final List<PaymentFormula> _paymentFormulas;

  @override
  FormulasPopulatedState createState() => FormulasPopulatedState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class FormulasPopulatedState extends State<FormulasPopulated> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget._paymentFormulas.isEmpty)
            const Center(
              heightFactor: 5,
              child: Text('It seems empty here'),
            )
          else ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget._paymentFormulas.length,
            itemBuilder: (context, index) {
              return PaymentFormulaTile(
                paymentFormula: widget._paymentFormulas[index],
                onTap: () => Navigator.of(context).pop(widget._paymentFormulas[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index)
              => const Divider(height: 0, indent: 70, endIndent: 20,)
          ),
        ],
      ),
    );
  }
}