part of 'search_bloc.dart';

enum Status {
  idle,
  loading,
}

class SearchState {
  SearchState({
    this.string = '',
    this.results = const [],
    this.status = Status.idle,
  });

  final Status status;
  final String string;
  List<Athlete> results = [];

  SearchState copyWith({
    String? string,
    List<Athlete>? results,
    Status? status,
  }) {
    return SearchState(
      string: string ?? this.string,
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }
}