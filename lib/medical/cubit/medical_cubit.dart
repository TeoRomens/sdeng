import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';

part 'medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  MedicalCubit({
    required MedicalsRepository medicalsRepository
  }) : _medicalsRepository = medicalsRepository,
       super(const MedicalState.initial());

  final MedicalsRepository _medicalsRepository;

  Future<void> getExpiredMedicals({int? limit}) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      final medicals = await _medicalsRepository.getExpiredMedicals(
        limit: limit
      );
      emit(state.copyWith(
          status: MedicalStatus.populated,
          expiredMedicals: medicals
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MedicalStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> getExpiringMedicals({int? limit}) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      final medicals = await _medicalsRepository.getExpiringMedicals(
          limit: limit
      );
      emit(state.copyWith(
          status: MedicalStatus.populated,
          expiringMedicals: medicals
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MedicalStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> getGoodMedicals({int? limit}) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      final medicals = await _medicalsRepository.getGoodMedicals(
          limit: limit
      );
      emit(state.copyWith(
          status: MedicalStatus.populated,
          goodMedicals: medicals
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MedicalStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> getUnknownMedicals({int? limit}) async {
    emit(state.copyWith(status: MedicalStatus.loading));
    try {
      final medicals = await _medicalsRepository.getUnknownMedicals(
          limit: limit
      );
      emit(state.copyWith(
          status: MedicalStatus.populated,
          unknownMedicals: medicals
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MedicalStatus.failure));
      addError(error, stackTrace);
    }
  }

}
