import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:storage/storage.dart';

part 'athletes_storage.dart';

/// {@template article_failure}
/// A base failure for the article repository failures.
/// {@endtemplate}
abstract class AthletesFailure with EquatableMixin implements Exception {
  /// {@macro article_failure}
  const AthletesFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template get_athletes_from_teamId_failure}
/// Thrown when fetching an athletes from a team fails.
/// {@endtemplate}
class GetAthletesFromTeamIdFailure extends AthletesFailure {
  /// {@macro get_athletes_from_teamId_failure}
  const GetAthletesFromTeamIdFailure(super.error);
}

/// {@template get_athletes_failure}
/// Thrown when fetching an athletes from a team fails.
/// {@endtemplate}
class GetAthletesFailure extends AthletesFailure {
  /// {@macro get_athletes_failure}
  const GetAthletesFailure(super.error);
}

/// {@template get_athletes_from_id}
/// Thrown when fetching an athlete.
/// {@endtemplate}
class GetAthleteFromIdFailure extends AthletesFailure {
  /// {@macro get_athletes_from_id}
  const GetAthleteFromIdFailure(super.error);
}

/// {@template get_athletes_list}
/// Thrown when fetching all athletes.
/// {@endtemplate}
class GetAthletesListFailure extends AthletesFailure {
  /// {@macro get_athletes_list}
  const GetAthletesListFailure(super.error);
}

/// {@template get_parent_from_athlete_id}
/// Thrown when fetching an athlete's parent.
/// {@endtemplate}
class GetParentFromAthleteIdFailure extends AthletesFailure {
  /// {@macro get_parent_from_athlete_id}
  const GetParentFromAthleteIdFailure(super.error);
}

/// {@template add_athlete_failure}
/// Thrown when adding an athletes fails.
/// {@endtemplate}
class AddAthleteFailure extends AthletesFailure {
  /// {@macro add_athlete_failure}
  const AddAthleteFailure(super.error);
}

/// {@template update_athlete_failure}
/// Thrown when updating an existing athlete fails.
/// {@endtemplate}
class UpdateAthleteFailure extends AthletesFailure {
  /// {@macro update_athlete_failure}
  const UpdateAthleteFailure(super.error);
}

/// {@template delete_athlete_failure}
/// Thrown when deleting an athlete fails.
/// {@endtemplate}
class DeleteAthleteFailure extends AthletesFailure {
  /// {@macro delete_athlete_failure}
  const DeleteAthleteFailure(super.error);
}

/// {@template search_athlete}
/// Thrown when fetching all athletes.
/// {@endtemplate}
class SearchAthleteFailure extends AthletesFailure {
  /// {@macro search_athlete}
  const SearchAthleteFailure(super.error);
}

/// A repository that manages article data.
class AthletesRepository {
  /// {@macro athletes_repository}
  const AthletesRepository({
    required FlutterSdengApiClient apiClient,
    required AthletesStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final FlutterSdengApiClient _apiClient;
  final AthletesStorage _storage;

  /// Requests an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete to return.
  Future<Athlete> getAthleteFromId(String athleteId) async {
    try {
      return await _apiClient.getAthleteFromId(athleteId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAthleteFromIdFailure(error), stackTrace);
    }
  }

  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Athlete>> getAthletesFromTeamId({
    required String teamId,
    int? limit,
  }) async {
    try {
      return await _apiClient.getAthletesFromTeamId(
        teamId: teamId,
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAthletesFromTeamIdFailure(error), stackTrace);
    }
  }

  Future<List<Athlete>> getAthletes({
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getAthletes(
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAthletesFailure(error), stackTrace);
    }
  }


  /// Add a new team
  ///
  /// Supported parameters:
  /// * [name] - The name of the team.
  Future<Athlete> addAthlete({
    required String teamId,
    required String name,
    required String surname,
    required String taxCode,
    String? email,
    String? phone,
    String? address,
    DateTime? birthdate,
  }) async {
    try {
      final athlete = await _apiClient.addAthlete(
        teamId: teamId,
        fullName: '$name $surname',
        taxCode: taxCode,
      );
      await _apiClient.addParent(
        athleteId: athlete.id,
      );
      await _apiClient.addMedical(
        athleteId: athlete.id,
      );
      return athlete;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddAthleteFailure(error), stackTrace);
    }
  }

  ///
  Future<Parent> getParentFromAthleteId(String athleteId) async {
    try {
      return await _apiClient.getParentFromAthleteId(athleteId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetParentFromAthleteIdFailure(error), stackTrace);
    }
  }

  Future<Athlete> updateAthlete({required Athlete athlete}) async {
    try {
      return await _apiClient.updateAthlete(
        id: athlete.id,
        fullName: athlete.fullName,
        fullAddress: athlete.fullAddress,
        taxCode: athlete.taxCode,
        birthDate: athlete.birthdate,
        phone: athlete.phone,
        email: athlete.email,
        paymentFormulaId: athlete.paymentFormulaId,
        teamId: athlete.teamId,
        archived: athlete.archived
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateAthleteFailure(error), stackTrace);
    }
  }

  /// Requests a list of all athletes with only essentials data.
  Future<List<Athlete>> getAthleteList() async {
    try {
      return await _apiClient.getAthletesList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetAthletesListFailure(error), stackTrace);
    }
  }


  /// Delete an athlete.
  ///
  /// Supported parameters:
  /// [id] - The id of the athlete to delete.
  Future<void> deleteAthlete({
    required String id,
  }) async {
    try {
      return await _apiClient.deleteAthlete(
        id: id,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAthleteFailure(error), stackTrace);
    }
  }

  Future<Parent> updateParent({
    required Parent parent
  }) async {
    try {
      return await _apiClient.updateParent(
          athleteId: parent.athleteId,
          fullName: parent.fullName,
          fullAddress: parent.fullAddress,
          phone: parent.phone,
          email: parent.email,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateAthleteFailure(error), stackTrace);
    }
  }

  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Athlete>> searchAthletes(String searchText) async {
    try {
      return await _apiClient.searchAthlete(searchText);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchAthleteFailure(error), stackTrace);
    }
  }

}
