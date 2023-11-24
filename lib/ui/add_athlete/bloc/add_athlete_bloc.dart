import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'add_athlete_state.dart';

class AddAthleteBloc extends Cubit<AddAthleteState> {
  AddAthleteBloc() : super(AddAthleteState());

  final AthletesRepository _athleteRepository = GetIt.instance.get<AthletesRepository>();
  final TeamsRepository _teamsRepository = GetIt.instance.get<TeamsRepository>();
  final PaymentsRepository _paymentsRepository = GetIt.instance.get<PaymentsRepository>();
  final ParentsRepository _parentsRepository = GetIt.instance.get<ParentsRepository>();
  final StorageRepository _storageRepository = GetIt.instance.get<StorageRepository>();

  nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  surnameChanged(String surname) {
    emit(state.copyWith(surname: surname));
  }

  numberChanged(String number) {
    emit(state.copyWith(number: int.parse(number)));
  }

  birthDayChanged(DateTime date) {
    emit(state.copyWith(birthDay: date));
  }

  bornCityChanged(String bornCity) {
    emit(state.copyWith(bornCity: bornCity));
  }

  addressChanged(String address) {
    emit(state.copyWith(address: address));
  }

  cityChanged(String city) {
    emit(state.copyWith(city: city));
  }

  taxIdChanged(String taxId) {
    emit(state.copyWith(taxId: taxId));
  }

  phoneChanged(String phone) {
    emit(state.copyWith(phone: phone));
  }

  emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  heightChanged(String height) {
    emit(state.copyWith(secondaRata: int.parse(height)));
  }

  weightChanged(String weight) {
    emit(state.copyWith(secondaRata: int.parse(weight)));
  }

  expiringDateChanged(DateTime date) {
    emit(state.copyWith(expiringDate: date));
  }

  upload(PlatformFile pickedFile) {
    emit(state.copyWith(pickedFile: pickedFile));
  }

  rataSwitchChanged(bool rataUnica) {
    emit(state.copyWith(rataUnica: rataUnica));
  }

  primaRataChanged(String primaRata) {
    emit(state.copyWith(primaRata: int.parse(primaRata)));
  }

  secondaRataChanged(String secondaRata) {
    emit(state.copyWith(secondaRata: int.parse(secondaRata)));
  }

  Future<void> submitted(String teamId) async {
    try {
      emit(state.copyWith(status: Status.submitting,));

      if(!checkForm()) {
        emit(state.copyWith(status: Status.failure, errorMessage: 'Complete all the fields'));
        return;
      }

      log('Adding new parent...');
      Parent parent = Parent(
        docId: '',
        name: state.parentName,
        surname: state.parentSurname,
        email: state.parentEmail,
        phone: state.parentPhone,
        taxId: state.parentTaxId,
      );
      String parentDocId = await _parentsRepository.addParent(parent);
      log('Parent Added!');

      log('Adding new athlete...');
      final athlete = Athlete(
          docId: '',
          name: state.name,
          surname: state.surname,
          birth: Timestamp.fromDate(state.birthDay!),
          teamId: teamId,
          number: state.number ?? 999,
          parentId: parentDocId,
          bornCity: state.bornCity,
          address: state.address,
          phone: state.phone,
          email: state.email,
          taxId: state.taxId,
          city: state.city,
          amount: state.primaRata + state.secondaRata,
      );
      String athleteDoc = await _athleteRepository.addAthlete(athlete);
      log('Athlete Added!');

      await _teamsRepository.updateTeam(teamId, athleteDoc);

      if(state.pickedFile != null){
        log('Uploading Med File...');
        final file = File(state.pickedFile!.path!);
        final path = '$teamId/med/${athlete.docId}.pdf';
        final metadata = SettableMetadata(
          customMetadata: {
            "expiring-date": state.expiringDate!.toIso8601String(),
          },
        );
        await _storageRepository.uploadFile(path, file, metadata);
        log('Med File uploaded!');
      }
      emit(state.copyWith(status: Status.success));

    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
      emit(state.copyWith(status: Status.idle, errorMessage: null));
    }
  }

  parentName(String name) {
    emit(state.copyWith(parentName: name));
  }

  parentSurname(String surname) {
    emit(state.copyWith(parentSurname: surname));
  }

  parentPhone(String phone) {
    emit(state.copyWith(parentPhone: phone));
  }

  parentEmail(String email) {
    emit(state.copyWith(parentEmail: email));
  }

  parentTaxId(String taxId) {
    emit(state.copyWith(parentTaxId: taxId));
  }

  bool checkForm() {
    if(state.name.isEmpty || state.surname.isEmpty || state.email.isEmpty || state.taxId.isEmpty || state.phone.isEmpty || state.bornCity.isEmpty || state.address.isEmpty || state.city.isEmpty || state.parentName.isEmpty || state.parentSurname.isEmpty || state.parentEmail.isEmpty || state.parentPhone.isEmpty || state.parentTaxId.isEmpty) {
      return false;
    }
    return true;
  }

}
