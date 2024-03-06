part of 'athletes_cubit.dart';

@immutable
abstract class AthletesState {}

class AthletesInitial extends AthletesState {}

class AthletesEmpty extends AthletesState {}

class AthletesError extends AthletesState {
  AthletesError({
    required this.error,
  });

  final String error;
}

class AthletesLoading extends AthletesState {}

class AthletesLoaded extends AthletesState {
  AthletesLoaded({
    required this.athletes,
  });

  final Map<String, Athlete> athletes;
}

class AthleteDetailLoaded extends AthletesState {
  AthleteDetailLoaded({
    required this.athlete,
    this.payments,
    this.medical,
    this.parent
  });

  final Athlete athlete;
  final Medical? medical;
  final Parent? parent;
  final List<Payment>? payments;
}
