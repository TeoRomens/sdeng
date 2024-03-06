import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/medical.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';

part 'athletes_state.dart';

class AthletesCubit extends Cubit<AthletesState> {
  AthletesCubit({required Repository repository})
      : _repository = repository,
        super(AthletesInitial());

  final Repository _repository;

  /// Map of app athletes cache in memory with id as the key
  Map<String, Athlete> _athletes = {};

  Future<void> loadAthleteDetailsFromId(String id) async {
    try {
      emit(AthletesLoading());
      final athlete = await _repository.loadAthleteFromId(id);
      final medical = await _repository.loadMedVisitFromAthleteId(id);
      final payments = await _repository.loadPaymentsFromAthleteId(id);
      final parent = await _repository.loadParentFromAthleteId(id);
      emit(AthleteDetailLoaded(
          athlete: athlete,
          medical: medical,
          payments: payments,
          parent: parent
      ));
    } catch (e) {
      emit(AthletesError(error: 'Error loading athlete. Please refresh.'));
      log(e.toString());
    }
  }

  //TODO: Improve by not fetching full athlete row in database
  Future<void> loadInitialAthletes() async {
    try {
      emit(AthletesLoading());
      final athletes = await _repository.loadAthletes();
      _athletes = athletes;
      emit(AthletesLoaded(athletes: _athletes));
    } catch (e) {
      emit(AthletesError(error: 'Error loading athletes. Please refresh.'));
      log(e.toString());
    }
  }

  Future<void> addAthlete(
      String teamId,
      String fullName,
      String taxCode
  ) async {
    try{
      emit(AthletesLoading());
      final athleteId = await _repository.addAthlete(teamId: teamId, fullName: fullName, taxCode: taxCode);
      final athlete = await _repository.loadAthleteFromId(athleteId);
      _athletes[athleteId] = athlete;
      emit(AthletesLoaded(athletes: _athletes));
    } catch (err) {
      emit(AthletesError(error: 'Error adding athlete. Please retry.'));
      log(err.toString());
    }
  }

  Future<void> editAthlete(
      String id,
      String fullName,
  ) async {
    try{
      await _repository.editAthlete(
        id: id,
        fullName: fullName,
      );
      _athletes[id] = await _repository.loadAthleteFromId(id);

    } catch (e) {
      emit(AthletesError(error: 'Error updating label "Full Name"'));
      log(e.toString());
    }
  }

  Future<void> updateFullName(String id, String newValue) async {
    await _repository.updateFullName(id, newValue);
  }

  Future<void> updateTaxId(String id, String newValue) async {
    await _repository.updateTaxId(id, newValue);
  }

  Future<void> updateBirthdate(String id, String newValue) async {
    await _repository.updateBirthdate(id, DateTime.parse(newValue));
  }

  Future<void> updateAddress(String id, String newValue) async {
    await _repository.updateAddress(id, newValue);
  }

  Future<void> updateEmail(String id, String newValue) async {
    await _repository.updateEmail(id, newValue);
  }

  Future<void> updatePhone(String id, String newValue) async {
    await _repository.updatePhone(id, newValue);
  }

  Future<void> updateParentName(String id, String newValue) async {
    await _repository.updateParentName(id, newValue);
  }

  Future<void> updateParentEmail(String id, String newValue) async {
    await _repository.updateParentEmail(id, newValue);
  }

  Future<void> updateParentAddress(String id, String newValue) async {
    await _repository.updateParentAddress(id, newValue);
  }
}
