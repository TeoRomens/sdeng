import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';

part 'medical_state.dart';

/// The `MedicalCubit` class manages the state of medical records within the application.
/// It communicates with the `MedicalsRepository` to fetch medical records based on their status:
/// expired, expiring, good, or unknown.
class MedicalCubit extends Cubit<MedicalState> {
  /// Creates a new instance of [MedicalCubit] with the provided [MedicalsRepository].
  MedicalCubit({required MedicalsRepository medicalsRepository})
      : _medicalsRepository = medicalsRepository,
        super(const MedicalState.initial());

  final MedicalsRepository _medicalsRepository;

  /// Fetches expired medical records, optionally limited by [limit].
  /// Emits a loading state, followed by either a populated state with data or a failure state.
  Future<void> getExpiredMedicals({int? limit}) async {
    await _fetchMedicals(
      fetchFunction: () => _medicalsRepository.getExpiredMedicals(limit: limit),
    );
  }

  /// Fetches expiring medical records, optionally limited by [limit].
  /// Emits a loading state, followed by either a populated state with data or a failure state.
  Future<void> getExpiringMedicals({int? limit}) async {
    await _fetchMedicals(
      fetchFunction: () => _medicalsRepository.getExpiringMedicals(limit: limit),
    );
  }

  /// Fetches good medical records, optionally limited by [limit].
  /// Emits a loading state, followed by either a populated state with data or a failure state.
  Future<void> getGoodMedicals({int? limit}) async {
    await _fetchMedicals(
      fetchFunction: () => _medicalsRepository.getGoodMedicals(limit: limit),
    );
  }

  /// Fetches unknown medical records, optionally limited by [limit].
  /// Emits a loading state, followed by either a populated state with data or a failure state.
  Future<void> getUnknownMedicals({int? limit}) async {
    await _fetchMedicals(
      fetchFunction: () => _medicalsRepository.getUnknownMedicals(limit: limit),
    );
  }

  /// A helper method to handle the fetching of medical records.
  /// It handles the common logic for fetching data, updating the state, and handling errors.
  Future<void> _fetchMedicals({
    required Future<List<Medical>> Function() fetchFunction,
  }) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      final medicals = await fetchFunction();
      emit(state.copyWith(
        status: MedicalStatus.populated,
        expiredMedicals: state.status == MedicalStatus.populated ? state.expiredMedicals : medicals,
        expiringMedicals: state.status == MedicalStatus.populated ? state.expiringMedicals : medicals,
        goodMedicals: state.status == MedicalStatus.populated ? state.goodMedicals : medicals,
        unknownMedicals: state.status == MedicalStatus.populated ? state.unknownMedicals : medicals,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MedicalStatus.failure));
      addError(error, stackTrace);
    }
  }
}

