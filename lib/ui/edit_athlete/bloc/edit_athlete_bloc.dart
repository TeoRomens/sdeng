import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';

part 'edit_athlete_event.dart';
part 'edit_athlete_state.dart';

class EditAthleteBloc extends Bloc<EditAthleteEvent, EditAthleteState> {
  EditAthleteBloc()
      :   super(EditAthleteState()) {
    on<SubmittedEvent>(_submittedEventHandler);
    on<UploadEvent>(_uploadEventHandler);
    on<NameChanged>(_nameChangedEventHandler);
    on<SurnameChanged>(_surnameChangedEventHandler);
    on<NumberChanged>(_numberChangedEventHandler);
    on<BirthdayChanged>(_birthDayChangedEventHandler);
    on<CityChanged>(_cityChangedEventHandler);
    on<BornCityChanged>(_bornCityChangedEventHandler);
    on<AddressChanged>(_addressChangedEventHandler);
    on<TaxIdChanged>(_taxIdChangedEventHandler);
    on<PhoneChanged>(_phoneChangedEventHandler);
    on<EmailChanged>(_emailChangedEventHandler);
    on<HeightChanged>(_heightChangedEventHandler);
    on<WeightChanged>(_weightChangedEventHandler);
    on<RataSwitchChangedEvent>(_rataSwitchChangedEventHandler);
    on<PrimaRataChangedEvent>(_primaRataChangedEventHandler);
    on<SecondaRataChangedEvent>(_secondaRataChangedEventHandler);
    on<ExpiringDateChanged>(_expiringDateChangedEventHandler);
    on<StepChangedEvent>(_stepChangedEventHandler);
    on<ParentNameChanged>(_parentNameEventHandler);
    on<ParentSurnameChanged>(_parentSurnameEventHandler);
    on<ParentPhoneChanged>(_parentPhoneEventHandler);
    on<ParentEmailChanged>(_parentEmailEventHandler);
    on<ParentTaxIdChanged>(_parentTaxIdEventHandler);
  }

  final AthletesRepository _athleteRepository = GetIt.instance.get<AthletesRepository>();
  final PaymentsRepository _paymentsRepository = GetIt.instance.get<PaymentsRepository>();
  final ParentsRepository _parentsRepository = GetIt.instance.get<ParentsRepository>();

  Future<void> _nameChangedEventHandler(
      NameChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _surnameChangedEventHandler(
      SurnameChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(surname: event.surname));
  }

  Future<void> _numberChangedEventHandler(
      NumberChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(number: int.parse(event.number)));
  }

  Future<void> _birthDayChangedEventHandler(
      BirthdayChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(birthDay: event.date));
  }

  Future<void> _bornCityChangedEventHandler(
      BornCityChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(bornCity: event.bornCity));
  }

  Future<void> _addressChangedEventHandler(
      AddressChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(address: event.address));
  }

  Future<void> _cityChangedEventHandler(
      CityChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(city: event.city));
  }

  Future<void> _taxIdChangedEventHandler(
      TaxIdChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(taxId: event.taxId));
  }

  Future<void> _phoneChangedEventHandler(
      PhoneChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(phone: event.phone));
  }

  Future<void> _emailChangedEventHandler(
      EmailChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _heightChangedEventHandler(
      HeightChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(secondaRata: int.parse(event.height)));
  }

  Future<void> _weightChangedEventHandler(
      WeightChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(secondaRata: int.parse(event.weight)));
  }

  Future<void> _expiringDateChangedEventHandler(
      ExpiringDateChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(expiringDate: event.date));
  }

  Future<void> _uploadEventHandler(
      UploadEvent event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(pickedFile: event.pickedFile));
  }

  Future<void> _rataSwitchChangedEventHandler(
      RataSwitchChangedEvent event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(rataUnica: event.rataUnica));
  }

  Future<void> _primaRataChangedEventHandler(
      PrimaRataChangedEvent event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(primaRata: int.parse(event.primaRata)));
  }

  Future<void> _secondaRataChangedEventHandler(
      SecondaRataChangedEvent event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(secondaRata: int.parse(event.secondaRata)));
  }

  Future<void> _stepChangedEventHandler(
      StepChangedEvent event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(currentStep: event.step));
  }

  Future<void> _parentNameEventHandler(
      ParentNameChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(parentName: event.name));
  }

  void _parentSurnameEventHandler(
      ParentSurnameChanged event,
      Emitter<EditAthleteState> emit,
      ) {
    emit(state.copyWith(parentSurname: event.surname));
  }

  Future<void> _parentPhoneEventHandler(
      ParentPhoneChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(parentPhone: event.phone));
  }

  Future<void> _parentEmailEventHandler(
      ParentEmailChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(parentEmail: event.email));
  }

  Future<void> _parentTaxIdEventHandler(
      ParentTaxIdChanged event,
      Emitter<EditAthleteState> emit,
      ) async {
    emit(state.copyWith(parentTaxId: event.taxId));
  }

  Future<void> _submittedEventHandler(
      SubmittedEvent event,
      Emitter<EditAthleteState> emit
      ) async {
    try {
      emit(state.copyWith(status: Status.submitting,));

      log('Updating athlete...');
      final newAthlete = Athlete(
          docId: event.athlete.docId,
          name: state.name ?? event.athlete.name,
          surname: state.surname ?? event.athlete.surname,
          bornCity: state.bornCity ?? event.athlete.bornCity,
          birth: state.birthDay != null ? Timestamp.fromDate(state.birthDay!) : event.athlete.birth,
          taxId: state.taxId ?? event.athlete.taxId,
          address: state.address ?? event.athlete.address,
          city: state.city ?? event.athlete.city,
          phone: state.phone ?? event.athlete.phone,
          email: state.email ?? event.athlete.email,
          number: state.number ?? event.athlete.number,
          teamId: event.athlete.teamId,
          paymentId: event.athlete.paymentId,
          parentId: event.athlete.parentId
      );
      await _athleteRepository.editAthlete(newAthlete);

      Payment newPayment = Payment(
        docId: event.payment.docId,
        athlete: event.athlete.docId,
        rataUnica: state.rataUnica ?? event.payment.rataUnica,
        primaRata: state.primaRata ?? event.payment.primaRata,
        secondaRata: state.secondaRata ?? event.payment.secondaRata,
        amount: state.amount ?? event.payment.amount,
        primaRataPaid: state.primaRataPaid ?? event.payment.secondaRataPaid,
        secondaRataPaid: state.secondaRataPaid ?? event.payment.secondaRataPaid,
      );
      await _paymentsRepository.editPayment(newPayment);

      Parent newParent = Parent(
        docId: event.parent.docId,
        name: state.parentName ?? event.parent.name,
        surname: state.parentSurname ?? event.parent.surname,
        email: state.parentEmail ?? event.parent.email,
        phone: state.parentPhone ?? event.parent.phone,
        taxId: state.parentTaxId ?? event.parent.taxId,
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
