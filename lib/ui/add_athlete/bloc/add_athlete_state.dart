part of 'add_athlete_bloc.dart';

enum Status {
  idle,
  submitting,
  failure,
  success
}

enum UploadStatus{
  idle,
  failure
}

class AddAthleteState extends Equatable {
  const AddAthleteState({
    this.name = '',
    this.surname = '',
    this.number,
    this.birthDay,
    this.bornCity = '',
    this.address = '',
    this.city = '',
    this.email = '',
    this.phone = '',
    this.taxId = '',
    this.expiringDate,
    this.primaRata,
    this.secondaRata = 0,
    this.rataUnica = true,
    this.status = Status.idle,
    this.pickedFile,
    this.uploadStatus = UploadStatus.idle,
    this.errorMessage = '',
    this.currentStep = 0,
    this.parentName = '',
    this.parentSurname = '',
    this.parentEmail = '',
    this.parentPhone = '',
    this.parentTaxId = '',
  });

  final String name;
  final String surname;
  final int? number;
  final String bornCity;
  final String address;
  final String city;
  final String taxId;
  final String email;
  final String phone;
  final DateTime? birthDay;
  final DateTime? expiringDate;
  final int? primaRata;
  final int secondaRata;
  final bool rataUnica;

  final Status status;
  final PlatformFile? pickedFile;
  final UploadStatus uploadStatus;
  final String errorMessage;

  final String parentName;
  final String parentSurname;
  final String parentPhone;
  final String parentEmail;
  final String parentTaxId;

  final int currentStep;

  AddAthleteState copyWith({
    String? name,
    String? surname,
    int? number,
    DateTime? birthDay,
    String? bornCity,
    String? address,
    String? city,
    String? email,
    String? phone,
    String? taxId,
    DateTime? expiringDate,
    int? height,
    int? weight,
    int? primaRata,
    int? secondaRata,
    bool? rataUnica,
    Status? status,
    PlatformFile? pickedFile,
    UploadStatus? uploadStatus,
    String? errorMessage,
    int? currentStep,
    String? parentName,
    String? parentSurname,
    String? parentPhone,
    String? parentEmail,
    String? parentTaxId,
  }) {
    return AddAthleteState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      number: number ?? this.number,
      birthDay: birthDay ?? this.birthDay,
      bornCity: bornCity ?? this.bornCity,
      address: address ?? this.address,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      taxId: taxId ?? this.taxId,
      expiringDate: expiringDate ?? this.expiringDate,
      primaRata: primaRata ?? this.primaRata,
      secondaRata: secondaRata ?? this.secondaRata,
      rataUnica: rataUnica ?? this.rataUnica,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      pickedFile: pickedFile ?? this.pickedFile,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      currentStep: currentStep ?? this.currentStep,
      parentName: parentName ?? this.parentName,
      parentSurname: parentSurname ?? this.parentSurname,
      parentEmail: parentEmail ?? this.parentEmail,
      parentPhone: parentPhone ?? this.parentPhone,
      parentTaxId: parentTaxId ?? this.parentTaxId,
    );
  }

  @override
  List<Object?> get props => [
    name,
    surname,
    number,
    bornCity,
    address,
    city,
    taxId,
    email,
    phone,
    birthDay,
    expiringDate,
    primaRata,
    secondaRata,
    rataUnica,
    status,
    pickedFile,
    uploadStatus,
    errorMessage,
    parentName,
    parentSurname,
    parentPhone,
    parentEmail,
    parentTaxId,
  ];
}