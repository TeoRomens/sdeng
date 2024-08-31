import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';

/// Base failure class for the news repository failures.
abstract class PaymentsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const PaymentsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching payments fails.
class GetPaymentsFailure extends PaymentsFailure {
  /// {@macro get_payment_failure}
  const GetPaymentsFailure(super.error);
}

/// Thrown when adding a payment fails.
class AddPaymentFailure extends PaymentsFailure {
  /// {@macro add_payment_failure}
  const AddPaymentFailure(super.error);
}

/// Thrown when fetching payments formulas fails.
class GetPaymentFormulasFailure extends PaymentsFailure {
  /// {@macro get_payment_formulas_failure}
  const GetPaymentFormulasFailure(super.error);
}

/// Thrown when adding a payment formula fails.
class AddPaymentFormulaFailure extends PaymentsFailure {
  /// {@macro add_payment_formula_failure}
  const AddPaymentFormulaFailure(super.error);
}

/// Thrown when editing a payment formula fails.
class UpdatePaymentFormulaFailure extends PaymentsFailure {
  /// {@macro update_payment_formula_failure}
  const UpdatePaymentFormulaFailure(super.error);
}

/// Thrown when fetching payments formulas fails.
class GetPaymentFormulaFromAthleteIdFailure extends PaymentsFailure {
  /// {@macro get_payment_formulas_failure}
  const GetPaymentFormulaFromAthleteIdFailure(super.error);
}

/// Thrown when deleting payment fails.
class DeletePaymentFailure extends PaymentsFailure {
  /// {@macro delete_payment_failure}
  const DeletePaymentFailure(super.error);
}

/// A repository that manages teams data.
class PaymentsRepository {
  /// {@macro teams_repository}
  const PaymentsRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests payments data.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Payment>> getPayments({
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getPayments(
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPaymentsFailure(error), stackTrace);
    }
  }

  /// Requests payments data from an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The athlete id to get payments.
  Future<List<Payment>> getPaymentsFromAthleteId(String athleteId) async {
    try {
      return await _apiClient.getPaymentsFromAthleteId(
        athleteId: athleteId,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPaymentsFailure(error), stackTrace);
    }
  }

  /// Add a new payment
  ///
  /// Supported parameters:
  /// * [athleteId] - The name of the team.
  Future<Payment> addPayment({
    required String cause,
    required double amount,
    required PaymentType type,
    required PaymentMethod method,
    String? athleteId,
  }) async {
    try {
      return await _apiClient.addPayment(
        athleteId: athleteId,
        cause: cause,
        amount: amount,
        paymentType: type,
        paymentMethod: method,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddPaymentFailure(error), stackTrace);
    }
  }

  /// Requests payments data.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<PaymentFormula>> getPaymentFormulas({
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getPaymentFormulas(
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetPaymentFormulasFailure(error), stackTrace);
    }
  }

  /// Add a new payment formula
  ///
  /// Supported parameters:
  Future<PaymentFormula> addPaymentFormula({
    required String name,
    required bool full,
    required num amount1,
    required DateTime date1,
    num? amount2,
    DateTime? date2,
  }) async {
    try {
      return await _apiClient.addPaymentFormula(
        name: name,
        full: full,
        amount1: amount1,
        date1: date1,
        amount2: amount2,
        date2: date2,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddPaymentFormulaFailure(error), stackTrace);
    }
  }

  /// Update a new payment formula
  ///
  /// Supported parameters:
  Future<PaymentFormula> updatePaymentFormula({
    required String id,
    required String name,
    required bool full,
    required num amount1,
    required DateTime date1,
    num? amount2,
    DateTime? date2,
  }) async {
    try {
      return await _apiClient.updatePaymentFormula(
        id: id,
        name: name,
        full: full,
        amount1: amount1,
        date1: date1,
        amount2: amount2,
        date2: date2,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          UpdatePaymentFormulaFailure(error), stackTrace,);
    }
  }

  /// Requests payment formula from an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The athlete id to get payments.
  Future<PaymentFormula?> getPaymentFormulaFromAthleteId(
      String athleteId,) async {
    try {
      return await _apiClient.getPaymentFormulaFromAthleteId(
        athleteId: athleteId,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          GetPaymentFormulaFromAthleteIdFailure(error), stackTrace,);
    }
  }

  /// Delete a payment.
  ///
  /// Supported parameters:
  /// [paymentId] - The id of the payment to delete.
  Future<void> deletePayment(String paymentId) async {
    try {
      await _apiClient.deletePayment(
        id: paymentId,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeletePaymentFailure(error), stackTrace);
    }
  }
}
