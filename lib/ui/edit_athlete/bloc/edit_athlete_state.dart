part of 'edit_athlete_bloc.dart';

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

class EditAthleteState {
  EditAthleteState({
    this.name,
    this.surname,
    this.height,
    this.weight,
    this.number,
    this.birthDay,
    this.bornCity,
    this.address,
    this.city,
    this.email,
    this.phone,
    this.taxId,
    this.expiringDate,
    this.primaRata,
    this.primaRataPaid,
    this.secondaRata,
    this.secondaRataPaid,
    this.rataUnica,
    this.amount,
    this.status = Status.idle,
    this.pickedFile,
    this.uploadStatus = UploadStatus.idle,
    this.errorMessage,
    this.currentStep = 0,
    this.parentName,
    this.parentSurname,
    this.parentEmail,
    this.parentPhone,
    this.parentTaxId
  });

  final String? name;
  final String? surname;
  final int? height;
  final int? weight;
  final int? number;
  final String? bornCity;
  final String? address;
  final String? city;
  final String? taxId;
  final String? email;
  final String? phone;
  final DateTime? birthDay;
  final DateTime? expiringDate;
  final int? primaRata;
  final int? secondaRata;
  final bool? primaRataPaid;
  final bool? secondaRataPaid;
  final bool? rataUnica;
  final int? amount;

  final Status status;
  final PlatformFile? pickedFile;
  final UploadStatus uploadStatus;
  final String? errorMessage;

  final String? parentName;
  final String? parentSurname;
  final String? parentPhone;
  final String? parentEmail;
  final String? parentTaxId;

  final int currentStep;

  EditAthleteState copyWith({
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
    bool? primaRataPaid,
    int? secondaRata,
    bool? secondaRataPaid,
    bool? rataUnica,
    int? amount,
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
    return EditAthleteState(
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
      weight: weight ?? this.weight,
      height: height ?? this.height,
      primaRata: primaRata ?? this.primaRata,
      primaRataPaid: primaRataPaid ?? this.primaRataPaid,
      secondaRata: secondaRata ?? this.secondaRata,
      secondaRataPaid: secondaRataPaid ?? this.secondaRataPaid,
      rataUnica: rataUnica ?? this.rataUnica,
      amount: amount ?? this.amount,
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
}