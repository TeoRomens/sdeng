import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';

/// Base failure class for the news repository failures.
abstract class TeamsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const TeamsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching feed fails.
class GetTeamsFailure extends TeamsFailure {
  /// {@macro get_feed_failure}
  const GetTeamsFailure(super.error);
}

/// Thrown when adding a team fails.
class AddTeamFailure extends TeamsFailure {
  /// {@macro add_team_failure}
  const AddTeamFailure(super.error);
}

/// Thrown when deleting a team fails.
class DeleteTeamFailure extends TeamsFailure {
  /// {@macro delete_team_failure}
  const DeleteTeamFailure(super.error);
}

/// Thrown when counting the number
/// of atgletes in a team fails.
class CountAthletesInTeamFailure extends TeamsFailure {
  /// {@macro count_athletes_in_team_failure}
  const CountAthletesInTeamFailure(super.error);
}


/// A repository that manages teams data.
class TeamsRepository {
  /// {@macro teams_repository}
  const TeamsRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Team>> getTeams({
    int? limit,
  }) async {
    try {
      return await _apiClient.getTeams(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetTeamsFailure(error), stackTrace);
    }
  }

  /// Add a new team
  ///
  /// Supported parameters:
  /// * [name] - The name of the team.
  Future<Team> addTeam({
    required String name,
  }) async {
    try {
      return await _apiClient.addTeam(
        name: name,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddTeamFailure(error), stackTrace);
    }
  }

  /// Delete a team
  ///
  /// Supported parameters:
  /// [id] - The id of the team to be deleted.
  Future<void> deleteTeam({
    required String id,
  }) async {
    try {
      return await _apiClient.deleteTeam(
        id: id,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteTeamFailure(error), stackTrace);
    }
  }

  /// Delete a team
  ///
  /// Supported parameters:
  /// [id] - The id of the team to be deleted.
  Future<int> countAthletesInTeam({
    required String id,
  }) async {
    try {
      return await _apiClient.countAthletesInTeam(
        id: id,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(CountAthletesInTeamFailure(error), stackTrace);
    }
  }


}
