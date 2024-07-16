import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a MMMM dd, yyyy [String].
  String get mDY {
    return DateFormat('MMMM d, yyyy').format(this);
  }

  /// Converts [DateTime] into a dd, mm, yyyy [String].
  String get dMY {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}

/// Extension to convert a [String] to a [DateTime] objects.
/// Since the slashes aren't supported natively.
extension StringEx on String {
  /// Converts [String] into a [DateTime] object.
  DateTime? get toDateTime {
    final format = DateFormat('dd/MM/yyyy');
    return isNotEmpty ? format.parse(this) : null;
  }
}
