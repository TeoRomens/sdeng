part of 'edit_athlete_bloc.dart';

class EditAthleteEvent{
  const EditAthleteEvent();
}

class NameChanged extends EditAthleteEvent {
  NameChanged({
    required this.name
  });

  final String name;
}

class SurnameChanged extends EditAthleteEvent {
  SurnameChanged({
    required this.surname
  });

  final String surname;
}

class NumberChanged extends EditAthleteEvent {
  NumberChanged({
    required this.number
  });

  final String number;
}

class BirthdayChanged extends EditAthleteEvent {
  BirthdayChanged({
    required this.date
  });

  final DateTime? date;
}

class BornCityChanged extends EditAthleteEvent {
  BornCityChanged({
    required this.bornCity
  });

  final String bornCity;
}

class AddressChanged extends EditAthleteEvent {
  AddressChanged({
    required this.address
  });

  final String address;
}

class CityChanged extends EditAthleteEvent {
  CityChanged({
    required this.city
  });

  final String city;
}

class EmailChanged extends EditAthleteEvent {
  EmailChanged({
    required this.email
  });

  final String email;
}

class PhoneChanged extends EditAthleteEvent {
  PhoneChanged({
    required this.phone
  });

  final String phone;
}

class TaxIdChanged extends EditAthleteEvent {
  TaxIdChanged({
    required this.taxId
  });

  final String taxId;
}

class HeightChanged extends EditAthleteEvent {
  HeightChanged({
    required this.height
  });

  final String height;
}

class WeightChanged extends EditAthleteEvent {
  WeightChanged({
    required this.weight
  });

  final String weight;
}

class ParentNameChanged extends EditAthleteEvent {
  ParentNameChanged({
    required this.name
  });

  final String name;
}

class ParentSurnameChanged extends EditAthleteEvent {
  ParentSurnameChanged({
    required this.surname
  });

  final String surname;
}

class ParentEmailChanged extends EditAthleteEvent {
  ParentEmailChanged({
    required this.email
  });

  final String email;
}

class ParentPhoneChanged extends EditAthleteEvent {
  ParentPhoneChanged({
    required this.phone
  });

  final String phone;
}

class ParentTaxIdChanged extends EditAthleteEvent {
  ParentTaxIdChanged({
    required this.taxId
  });

  final String taxId;
}

class ExpiringDateChanged extends EditAthleteEvent {
  ExpiringDateChanged({
    required this.date
  });

  final DateTime? date;
}

class UploadEvent extends EditAthleteEvent {
  UploadEvent({
    required this.pickedFile
  });

  final PlatformFile? pickedFile;
}


class RataSwitchChangedEvent extends EditAthleteEvent {
  const RataSwitchChangedEvent({
    required this.rataUnica
  });

  final bool rataUnica;
}

class PrimaRataChangedEvent extends EditAthleteEvent {
  const PrimaRataChangedEvent({
    required this.primaRata
  });

  final String primaRata;
}

class SecondaRataChangedEvent extends EditAthleteEvent {
  const SecondaRataChangedEvent({
    required this.secondaRata
  });

  final String secondaRata;
}

class SubmittedEvent extends EditAthleteEvent {
  const SubmittedEvent({
    required this.athlete,
    required this.parent,
    required this.payment
  });

  final Athlete athlete;
  final Parent parent;
  final Payment payment;

}

class StepChangedEvent extends EditAthleteEvent {
  StepChangedEvent({
    required this.step
  });

  final int? step;
}