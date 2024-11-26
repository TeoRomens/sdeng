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

/// The `AthleteCubit` manages the state and business logic for an athlete's data,
/// including loading, updating, and deleting operations related to athletes,
/// documents, payments, and medicals.
class AthleteCubit extends Cubit<AthleteState> {
  AthleteCubit({
    required AthletesRepository athletesRepository,
    required MedicalsRepository medicalsRepository,
    required PaymentsRepository paymentsRepository,
    required DocumentsRepository documentsRepository,
    required UserRepository userRepository,
    required String athleteId,
    Athlete? athlete,
  })  : _athletesRepository = athletesRepository,
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

  /// Initializes loading of athlete-related data, including athlete details, parent info,
  /// medical records, payments, documents, and payment formulas.
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
      emit(state.copyWith(
          status: AthleteStatus.failure, error: 'Error while loading.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Reloads the athlete's details from the repository.
  Future<void> reloadAthlete() async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      final result = await _athletesRepository.getAthleteFromId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, athlete: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error while loading athlete.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Reloads the parent information associated with the athlete from the repository.
  Future<void> reloadParent() async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      final result = await _athletesRepository.getParentFromAthleteId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, parent: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error while loading parent.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Deletes the athlete from the repository.
  Future<void> deleteAthlete() async {
    emit(state.copyWith(status: AthleteStatus.loading));
    try {
      await _athletesRepository.deleteAthlete(id: state.athleteId);
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure, error: 'Error deleting athlete.'));
      addError(error, stackTrace);
    }
  }

  /// Opens a document by downloading it from the repository and then opening it using the default app.
  Future<void> openDocument({required String path}) async {
    try {
      final bytes = await _documentsRepository.downloadFile(path: path);
      final tempDir = await getTemporaryDirectory();

      // Generate a unique file name based on the current time and file name.
      final filename =
          '${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}';
      final tempFilePath = '${tempDir.path}/$filename';

      final file = File(tempFilePath);
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthleteStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Uploads a file selected by the user and associates it with the athlete.
  Future<void> uploadFile() async {
    emit(state.copyWith(status: AthleteStatus.loading));
    try {
      final filePickerResult = await FilePicker.platform.pickFiles();
      if (filePickerResult != null) {
        await _documentsRepository.uploadAthleteDocument(
          file: File(filePickerResult.files.first.path!),
          athleteId: state.athleteId,
        );
      }
      final documents = await _documentsRepository.getDocumentsFromAthleteId(
          athleteId: state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, documents: documents));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure, error: 'Error uploading your file.'));
      addError(error, stackTrace);
    }
  }

  /// Generates and opens a "Richiesta Visita Medica" PDF document for the athlete.
  Future<void> generateRichiestaVisitaMedica() async {
    try {
      if (state.athlete != null) {
        final pdf = await _documentsRepository.generateRichiestaVisitaMedica(
            athlete: state.athlete!, user: _userRepository.sdengUser!);
        await OpenFile.open(pdf.path);
      }
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error generating Visita Medica.'));
      addError(error, stackTrace);
    }
  }

  /// Deletes a document associated with the athlete.
  Future<void> deleteDocument({required Document document}) async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      await _documentsRepository.deleteFile(path: document.path);
      final updatedDocuments = List<Document>.from(state.documents)
        ..remove(document);
      emit(state.copyWith(
          status: AthleteStatus.loaded, documents: updatedDocuments));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error deleting ${document.name}.'));
      addError(error, stackTrace);
    }
  }

  /// Updates the athlete's payment formula in the repository.
  Future<void> updatePaymentFormula({
    required String? formulaId,
  }) async {
    try {
      final updatedAthlete = state.athlete!.copyWith(paymentFormulaId: formulaId);
      await _athletesRepository.updateAthlete(athlete: updatedAthlete);
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error selecting this payment formula.'));
      addError(error, stackTrace);
    }
  }

  /// Reloads the medical information associated with the athlete from the repository.
  Future<void> reloadMedical() async {
    try {
      final result = await _medicalsRepository.getMedicalFromAthleteId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, medical: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error while loading medical visit.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Reloads the payment formula associated with the athlete from the repository.
  Future<void> reloadPaymentFormula() async {
    try {
      emit(state.copyWith(status: AthleteStatus.loading));
      final result = await _paymentsRepository.getPaymentFormulaFromAthleteId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, paymentFormula: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error while loading payment formula.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Reloads the medical information associated with the athlete from the repository.
  Future<void> reloadPayments() async {
    try {
      final result = await _paymentsRepository.getPaymentsFromAthleteId(state.athleteId);
      emit(state.copyWith(status: AthleteStatus.loaded, payments: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: AthleteStatus.failure,
          error: 'Error while loading payments.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }
}

