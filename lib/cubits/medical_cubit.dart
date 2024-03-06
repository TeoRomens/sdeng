import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/medical.dart';
import 'package:sdeng/repositories/repository.dart';

part 'medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  MedicalCubit({required Repository repository})
      : _repository = repository,
        super(MedicalInitial());

  final Repository _repository;

  final Map<String, Medical?> _medicals = {};

  Future<void> loadMedicalFromAthleteId(String id) async {
    if (_medicals[id] != null) {
      return;
    }
    try{
      emit(MedicalLoading());
      final medical = await _repository.loadMedVisitFromAthleteId(id);
      _medicals[id] = medical;
      emit(MedicalLoaded(medicals: _medicals));
    } catch (e) {
      emit(MedicalError(error: 'Error loading medical visit. Please retry.'));
      log(e.toString());
    }
    /*
    final data = await supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .match({'athlete_id': athleteId}).single();
     */
  }

  Future<void> loadMedicals() async {
    emit(MedicalLoading());
    final medicals = await _repository.loadMedicals();
    emit(MedicalLoaded(medicals: medicals));
  }

  Future<void> getMedicalExpireSoon() async {
    emit(MedicalLoading());
    final medicals = await _repository.loadExpiredMedVisits();
    medicals.map((medVisit) => _medicals[medVisit.athleteId] = medVisit);
    emit(MedicalLoaded(medicals: _medicals));
  }

  Future<void> getMedicalGood() async {
    emit(MedicalLoading());
    final medicals = await _repository.loadExpiredMedVisits();
    medicals.map((medVisit) => _medicals[medVisit.athleteId] = medVisit);
    emit(MedicalLoaded(medicals: _medicals));
  }

  Future<void> loadUnknownMedVisits() async {
    emit(MedicalLoading());
    final medicals = await _repository.loadUnknownMedVisits();
    medicals.map((medVisit) => _medicals[medVisit.athleteId] = medVisit);
    emit(MedicalLoaded(medicals: _medicals));
  }

  Future<void> addMedical(String athleteId, DateTime expirationDate, MedType type) async {
    final med = Medical.create(
        athleteId: athleteId,
        expirationDate: expirationDate,
        type: type,
    );

    emit(MedicalLoaded(medicals: _medicals));
  }

  List<Medical> getMedicalsGood() {
    final medicals = <Medical>[];
    _medicals.forEach((key, med) {
      if(med != null &&
         med.expirationDate!.isAfter(DateTime.now().add(const Duration(days: 14))))
      {
        medicals.add(med);
      }
    });
    return medicals;
  }

  List<Medical> getMedicalsExpiringSoon() {
    final medicals = <Medical>[];
    _medicals.forEach((key, med) {
      if(med != null &&
         med.expirationDate!.isBefore(DateTime.now().add(const Duration(days: 14))) &&
         med.expirationDate!.isAfter(DateTime.now()))
      {
        medicals.add(med);
      }
    });
    return medicals;
  }

  List<Medical> getMedicalsExpired() {
    final medicals = <Medical>[];
    _medicals.forEach((key, med) {
      if(med != null &&
         med.expirationDate!.isBefore(DateTime.now()))
      {
        medicals.add(med);
      }
    });
    return medicals;
  }

  List<String> getMedicalsUnknown() {
    final ids = <String>[];
    _medicals.forEach((key, med) {
      if(med == null) {
        ids.add(key);
      }
    });
    return ids;
  }
}
