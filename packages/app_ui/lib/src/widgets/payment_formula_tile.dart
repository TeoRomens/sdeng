import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';

/// A tile widget for displaying a [PaymentFormula] item.
class PaymentFormulaTile extends StatelessWidget {
  /// Creates a [PaymentFormulaTile] widget.
  ///
  /// The [paymentFormula] parameter is required and represents the payment formula
  /// to be displayed in the tile. The [onTap] callback is optional and will be
  /// triggered when the tile is tapped. The [trailing] widget is optional and
  /// will be displayed at the end of the tile, replacing the default chevron icon.
  const PaymentFormulaTile({
    required this.paymentFormula,
    this.onTap,
    this.trailing,
    super.key,
  });

  /// The payment formula to be displayed in the tile.
  final PaymentFormula paymentFormula;

  /// The widget to display at the end of the tile.
  /// If not provided, a default chevron icon is used.
  final Widget? trailing;

  /// The callback function that is triggered when the tile is tapped.
  /// If not provided, the tile will pop the current route with the [paymentFormula].
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.brightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          FeatherIcons.dollarSign,
          color: Colors.black, // Ensure the icon color matches design guidelines
        ),
      ),
      title: Text(
        paymentFormula.name,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
      ),
      subtitle: Text(
        paymentFormula.full ? 'Full' : 'Partial',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: trailing ??
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(FeatherIcons.chevronRight),
          ),
      onTap: onTap ?? () => Navigator.of(context).pop(paymentFormula),
    );
  }
}
