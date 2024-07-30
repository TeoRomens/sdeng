import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';

/// Base failure class for the news repository failures.
abstract class MedicalsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const MedicalsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching medicals fails.
class GetMedicalsFailure extends MedicalsFailure {
  /// {@macro get_medicals_failure}
  const GetMedicalsFailure(super.error);
}

/// Thrown when fetching the medical fails.
class GetMedicalFromAthleteFailure extends MedicalsFailure {
  /// {@macro get_medical_from_athlete_failure}
  const GetMedicalFromAthleteFailure(super.error);
}

/// Thrown when fetching expiring medicals fails.
class GetExpiringMedicalsFailure extends MedicalsFailure {
  /// {@macro get_expiring_medicals_failure}
  const GetExpiringMedicalsFailure(super.error);
}

/// Thrown when fetching expired medicals fails.
class GetExpiredMedicalsFailure extends MedicalsFailure {
  /// {@macro get_expired_medicals_failure}
  const GetExpiredMedicalsFailure(super.error);
}


/// Thrown when fetching good medicals fails.
class GetGoodMedicalsFailure extends MedicalsFailure {
  /// {@macro get_good_medicals_failure}
  const GetGoodMedicalsFailure(super.error);
}

/// Thrown when fetching unknown medicals fails.
class GetUnknownMedicalsFailure extends MedicalsFailure {
  /// {@macro get_unknown_medicals_failure}
  const GetUnknownMedicalsFailure(super.error);
}

/// Thrown when adding a medical fails.
class AddMedicalFailure extends MedicalsFailure {
  /// {@macro add_medical_failure}
  const AddMedicalFailure(super.error);
}

/// Thrown when adding a medical fails.
class UpdateMedicalFailure extends MedicalsFailure {
  /// {@macro add_medical_failure}
  const UpdateMedicalFailure(super.error);
}

/// A repository that manages medicals data.
class MedicalsRepository {
  /// {@macro teams_repository}
  const MedicalsRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests medical visits.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
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
  /// Supported parameters:
  /// [athleteId] - The id of the athlete
  /// * [limit] - The number of results to return.
  Future<Medical?> getMedicalFromAthleteId(
    String athleteId, {
    int? limit,
  }) async {
    try {
      return await _apiClient.getMedicalFromAthleteId(
        athleteId: athleteId,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMedicalFromAthleteFailure(error), stackTrace);
    }
  }

  /// Requests expired medical visits.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
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
  /// Supported parameters:
  /// * [limit] - The number of results to return.
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
  /// Supported parameters:
  /// * [limit] - The number of results to return.
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
  /// Supported parameters:
  /// * [limit] - The number of results to return.
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

  /// Requests unknown medical visits.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  /// [expire] - The expiring date.
  /// [type] - The type of medical visit.
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

  Future<Medical> updateMedical({required Medical medical}) async {
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
