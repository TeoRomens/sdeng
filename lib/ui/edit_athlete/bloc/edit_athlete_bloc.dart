import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';

part 'edit_athlete_state.dart';

class EditAthleteBloc extends Cubit<EditAthleteState> {
  EditAthleteBloc() : super(EditAthleteState());

  final AthletesRepository _athleteRepository = Get.find();
  final ParentsRepository _parentsRepository = Get.find();

  nameChangedEventHandler(String name) {
    emit(state.copyWith(name: name));
  }

  surnameChangedEventHandler(String surname)  {
    emit(state.copyWith(surname: surname));
  }

  numberChangedEventHandler(String number)  {
    emit(state.copyWith(number: int.parse(number)));
  }

  birthDayChangedEventHandler(DateTime date)  {
    emit(state.copyWith(birthDay: date));
  }

  bornCityChangedEventHandler(String bornCity)  {
    emit(state.copyWith(bornCity: bornCity));
  }

  addressChangedEventHandler(String address)  {
    emit(state.copyWith(address: address));
  }

  cityChangedEventHandler(String city)  {
    emit(state.copyWith(city: city));
  }

  taxIdChangedEventHandler(String taxId)  {
    emit(state.copyWith(taxId: taxId));
  }

  phoneChangedEventHandler(String phone)  {
    emit(state.copyWith(phone: phone));
  }

  emailChangedEventHandler(String email)  {
    emit(state.copyWith(email: email));
  }

  expiringDateChangedEventHandler(DateTime date)  {
    emit(state.copyWith(expiringDate: date));
  }

  uploadEventHandler(PlatformFile pickedFile)  {
    emit(state.copyWith(pickedFile: pickedFile));
  }

  primaRataChangedEventHandler(String primaRata)  {
    emit(state.copyWith(primaRata: int.parse(primaRata)));
  }

  secondaRataChangedEventHandler(String secondaRata)  {
    emit(state.copyWith(secondaRata: int.parse(secondaRata)));
  }

  parentNameEventHandler(String name)  {
    emit(state.copyWith(parentName: name));
  }

  parentSurnameEventHandler(String surname) {
    emit(state.copyWith(parentSurname: surname));
  }

  parentPhoneEventHandler(String phone)  {
    emit(state.copyWith(parentPhone: phone));
  }

  parentEmailEventHandler(String email)  {
    emit(state.copyWith(parentEmail: email));
  }

  parentTaxIdEventHandler(String taxId)  {
    emit(state.copyWith(parentTaxId: taxId));
  }

  Future<void> submittedEventHandler(Athlete oldAthlete, Parent oldParent) async {
    try {
      emit(state.copyWith(status: Status.submitting,));

      log('Updating athlete...');
      final newAthlete = Athlete(
          docId: oldAthlete.docId,
          name: state.name ?? oldAthlete.name,
          surname: state.surname ?? oldAthlete.surname,
          bornCity: state.bornCity ?? oldAthlete.bornCity,
          birth: state.birthDay != null ? Timestamp.fromDate(state.birthDay!) : oldAthlete.birth,
          taxId: state.taxId ?? oldAthlete.taxId,
          address: state.address ?? oldAthlete.address,
          city: state.city ?? oldAthlete.city,
          phone: state.phone ?? oldAthlete.phone,
          email: state.email ?? oldAthlete.email,
          number: state.number ?? oldAthlete.number,
          teamId: oldAthlete.teamId,
          parentId: oldAthlete.parentId,
          amount: state.amount ?? oldAthlete.amount,
      );
      await _athleteRepository.editAthlete(newAthlete);

      Parent newParent = Parent(
        docId: oldParent.docId,
        name: state.parentName ?? oldParent.name,
        surname: state.parentSurname ?? oldParent.surname,
        email: state.parentEmail ?? oldParent.email,
        phone: state.parentPhone ?? oldParent.phone,
        taxId: state.parentTaxId ?? oldParent.taxId,
      );
      await _parentsRepository.editParent(newParent);

      emit(state.copyWith(status: Status.success));

    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
      emit(state.copyWith(status: Status.idle, errorMessage: null));
    }
  }
}
