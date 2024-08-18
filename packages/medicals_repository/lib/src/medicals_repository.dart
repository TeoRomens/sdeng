import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';

/// Base failure class for the medicals repository failures.
///
/// This abstract class is the base for all failure classes in the
/// `MedicalsRepository`. It provides a common interface for all exceptions
/// related to medicals operations.
abstract class MedicalsFailure with EquatableMixin implements Exception {
  /// Creates a [MedicalsFailure] with the given error.
  ///
  /// The [error] parameter is the exception that was caught.
  const MedicalsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching medicals fails.
///
/// This exception is thrown when an error occurs while fetching the list of
/// medicals.
class GetMedicalsFailure extends MedicalsFailure {
  /// Creates a [GetMedicalsFailure] with the given error.
  const GetMedicalsFailure(super.error);
}

/// Thrown when fetching a medical for a specific athlete fails.
///
/// This exception is thrown when an error occurs while fetching medical data
/// for a specific athlete.
class GetMedicalFromAthleteFailure extends MedicalsFailure {
  /// Creates a [GetMedicalFromAthleteFailure] with the given error.
  const GetMedicalFromAthleteFailure(super.error);
}

/// Thrown when fetching expiring medicals fails.
///
/// This exception is thrown when an error occurs while fetching medicals
/// that are about to expire.
class GetExpiringMedicalsFailure extends MedicalsFailure {
  /// Creates a [GetExpiringMedicalsFailure] with the given error.
  const GetExpiringMedicalsFailure(super.error);
}

/// Thrown when fetching expired medicals fails.
///
/// This exception is thrown when an error occurs while fetching medicals
/// that have expired.
class GetExpiredMedicalsFailure extends MedicalsFailure {
  /// Creates a [GetExpiredMedicalsFailure] with the given error.
  const GetExpiredMedicalsFailure(super.error);
}

/// Thrown when fetching good medicals fails.
///
/// This exception is thrown when an error occurs while fetching medicals
/// that are considered to be in good standing.
class GetGoodMedicalsFailure extends MedicalsFailure {
  /// Creates a [GetGoodMedicalsFailure] with the given error.
  const GetGoodMedicalsFailure(super.error);
}

/// Thrown when fetching unknown medicals fails.
///
/// This exception is thrown when an error occurs while fetching medicals
/// with unknown status.
class GetUnknownMedicalsFailure extends MedicalsFailure {
  /// Creates a [GetUnknownMedicalsFailure] with the given error.
  const GetUnknownMedicalsFailure(super.error);
}

/// Thrown when adding a medical fails.
///
/// This exception is thrown when an error occurs while adding a new medical record.
class AddMedicalFailure extends MedicalsFailure {
  /// Creates a [AddMedicalFailure] with the given error.
  const AddMedicalFailure(super.error);
}

/// Thrown when updating a medical fails.
///
/// This exception is thrown when an error occurs while updating an existing
/// medical record.
class UpdateMedicalFailure extends MedicalsFailure {
  /// Creates a [UpdateMedicalFailure] with the given error.
  const UpdateMedicalFailure(super.error);
}

/// A repository that manages medicals data.
///
/// This class provides methods to fetch, add, and update medical records.
/// It uses the [FlutterSdengApiClient] to perform API operations related
/// to medical records.
class MedicalsRepository {
  /// Creates a [MedicalsRepository] with the given [apiClient].
  ///
  /// The [apiClient] parameter is used to perform API operations related
  /// to medical records.
  const MedicalsRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests medical visits.
  ///
  /// This method fetches a list of medical records. You can specify the
  /// number of results to return with the [limit] parameter.
  ///
  /// Throws [GetMedicalsFailure] if the operation fails.
  Future<List<Medical>> getMedicals({
    int? limit,
  }) async {
    try {
      return await _apiClient.getMedicals(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMedicalsFailure(error), stackTrace);
    }
  }

  /// Requests medical visit of a specific athlete.
  ///
  /// This method fetches medical records for a specific athlete identified
  /// by the [athleteId]. You can specify the number of results to return
  /// with the [limit] parameter.
  ///
  /// Throws [GetMedicalFromAthleteFailure] if the operation fails.
  Future<Medical?> getMedicalFromAthleteId(
      String athleteId, {
        int? limit,
      }) async {
    try {
      return await _apiClient.getMedicalFromAthleteId(
        athleteId: athleteId,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetMedicalFromAthleteFailure(error), stackTrace,
      );
    }
  }

  /// Requests expired medical visits.
  ///
  /// This method fetches a list of medical records that have expired. You
  /// can specify the number of results to return with the [limit] parameter.
  ///
  /// Throws [GetExpiredMedicalsFailure] if the operation fails.
  Future<List<Medical>> getExpiredMedicals({
    int? limit,
  }) async {
    try {
      return await _apiClient.getExpiredMedicals(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetExpiredMedicalsFailure(error), stackTrace);
    }
  }

  /// Requests expiring medical visits.
  ///
  /// This method fetches a list of medical records that are about to expire.
  /// You can specify the number of results to return with the [limit] parameter.
  ///
  /// Throws [GetExpiringMedicalsFailure] if the operation fails.
  Future<List<Medical>> getExpiringMedicals({
    int? limit,
  }) async {
    try {
      return await _apiClient.getExpiringMedicals(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetExpiringMedicalsFailure(error), stackTrace);
    }
  }

  /// Requests good medical visits.
  ///
  /// This method fetches a list of medical records that are in good standing.
  /// You can specify the number of results to return with the [limit] parameter.
  ///
  /// Throws [GetGoodMedicalsFailure] if the operation fails.
  Future<List<Medical>> getGoodMedicals({
    int? limit,
  }) async {
    try {
      return await _apiClient.getGoodMedicals(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetGoodMedicalsFailure(error), stackTrace);
    }
  }

  /// Requests unknown medical visits.
  ///
  /// This method fetches a list of medical records with an unknown status.
  /// You can specify the number of results to return with the [limit] parameter.
  ///
  /// Throws [GetUnknownMedicalsFailure] if the operation fails.
  Future<List<Medical>> getUnknownMedicals({
    int? limit,
  }) async {
    try {
      return await _apiClient.getUnknownMedicals(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetUnknownMedicalsFailure(error), stackTrace);
    }
  }

  /// Adds a new medical record.
  ///
  /// This method adds a new medical record with the specified [athleteId],
  /// [expire] date, and [type]. The method returns the added [Medical] object.
  ///
  /// Throws [AddMedicalFailure] if the operation fails.
  Future<Medical> addMedical({
    required String athleteId,
    required DateTime expire,
    required MedType type,
  }) async {
    try {
      return await _apiClient.addMedical(
        athleteId: athleteId,
        expire: expire,
        type: type,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddMedicalFailure(error), stackTrace);
    }
  }

  /// Updates an existing medical record.
  ///
  /// This method updates the specified [medical] record. It returns the
  /// updated [Medical] object.
  ///
  /// Throws [UpdateMedicalFailure] if the operation fails.
  Future<Medical> updateMedical({
    required Medical medical,
  }) async {
    try {
      return await _apiClient.updateMedical(
        athleteId: medical.athleteId,
        expire: medical.expire!,
        medType: medical.type!,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateMedicalFailure(error), stackTrace);
    }
  }
}
