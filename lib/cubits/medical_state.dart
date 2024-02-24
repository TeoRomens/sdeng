part of 'medical_cubit.dart';

@immutable
abstract class MedicalState {}

class MedicalInitial extends MedicalState {}

class MedicalEmpty extends MedicalState {}

class MedicalLoading extends MedicalState {}

class MedicalError extends MedicalState {
  MedicalError({
    required this.error,
  });

  final String error;
}

class MedicalLoaded extends MedicalState {
  MedicalLoaded({
    required this.medicals,
  });

  final Map<String, Medical?> medicals;
}