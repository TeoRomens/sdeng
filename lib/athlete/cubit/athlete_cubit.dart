import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'athlete_state.dart';

class AthleteCubit extends Cubit<AthleteState> {
  AthleteCubit({
    required AthletesRepository athletesRepository,
    required MedicalsRepository medicalsRepository,
    required PaymentsRepository paymentsRepository,
    required DocumentsRepository documentsRepository,
    required UserRepository userRepository,
    required String athleteId,
    Athlete? athlete,
  }) : _athletesRepository = athletesRepository,
       _medicalsRepository = medicalsRepository,
       _paymentsRepository = paymentsRepository,
       _documentsRepository = documentsRepository,
       _userRepository = userRepository,
       super(AthleteState.initial(athleteId: athleteId, athlete: athlete));

  final AthletesRepository _athletesRepository;
  final MedicalsRepository _medicalsRepository;
  final DocumentsRepository _documentsRepository;
  final PaymentsRepository _paymentsRepository;
  final UserRepository _userRepository;

  Future<void> initLoading() async {
    emit(state.copyWith(status: AthleteStatus.loading));
    try {
      final results = await Future.wait([
        _athletesRepository.getAthleteFromId(state.athleteId),
        _athletesRepository.getParentFromAthleteId(state.athleteId),
        _medicalsRepository.getMedicalFromAthleteId(state.athleteId),
        _paymentsRepository.getPaymentsFromAthleteId(state.athleteId),
        _documentsRepository.getDocumentsFromAthleteId(athleteId: state.athleteId),
        _paymentsRepository.getPaymentFormulaFromAthleteId(state.athleteId),
      ]);

      emit(state.copyWith(
        status: AthleteStatus.loaded,
        athlete: results[0] as Athlete,
        parent: results[1] as Parent,
        medical: results[2] as Medical?,
        payments: results[3] as List<Payment>,
        documents: results[4] as List<Document>,
        paymentFormula: results[5] as PaymentFormula?,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure, error: 'Error while loading.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> reloadAthlete() async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      final result = await _athletesRepository.getAthleteFromId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, athlete: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure, error: 'Error while reloading athlete.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> reloadParent() async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      final result = await _athletesRepository.getParentFromAthleteId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, parent: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure, error: 'Error while reloading parent.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> deleteAthlete() async {
    emit(state.copyWith(status: AthleteStatus.loading));
    try {
      await _athletesRepository.deleteAthlete(id: state.athleteId);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> addMedical({
    required MedType type,
    required DateTime expire,
  }) async {
    emit(state.copyWith(status: AthleteStatus.loading));
    try {
      final medical = await _medicalsRepository.addMedical(
          athleteId: state.athleteId,
          expire: expire,
          type: type
      );
      emit(state.copyWith(status: AthleteStatus.loaded, medical: medical));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> openDocument({required String path}) async {
    try {
      final bytes = await _documentsRepository.downloadFile(
          path: path,
      );

      final tempDir = await getTemporaryDirectory();
      // Unique file name
      final filename = '${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}';
      // Create a temporary file path
      final tempFilePath = '${tempDir.path}/$filename';

      final file = File(tempFilePath);
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);

    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> uploadFile() async {
    try {
      final filePickerResult = await FilePicker.platform.pickFiles();
      if(filePickerResult != null){
        await _documentsRepository.uploadAthleteDocument(
            file: File(filePickerResult.files.first.path!),
            athleteId: state.athleteId,
        );
      }
      final documents = await _documentsRepository.getDocumentsFromAthleteId(athleteId: state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, documents: documents));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure, error: 'Error uploading your file.'));
      addError(error, stackTrace);
    }
  }

  Future<void> generateRichiestaVisitaMedica() async {
    try {
      if(state.athlete != null){
        final pdf = await _documentsRepository.generateRichiestaVisitaMedica(
          athlete: state.athlete!,
          user: _userRepository.sdengUser!
        );
        await OpenFile.open(pdf.path);
      }
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure, error: 'Error uploading your file.'));
      addError(error, stackTrace);
    }
  }
}
