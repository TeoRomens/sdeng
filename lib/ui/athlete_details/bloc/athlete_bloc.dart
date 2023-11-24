import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:sdeng/util/message_util.dart';
import 'package:sdeng/util/pdf_service.dart';

part 'athlete_state.dart';

class AthleteBloc extends Cubit<AthleteState> {
   AthleteBloc({
     required Athlete athlete
   }) : super(AthleteState(athlete: athlete));

   final AthletesRepository _athletesRepository = GetIt.instance<AthletesRepository>();
   final ParentsRepository _parentsRepository = GetIt.instance<ParentsRepository>();
   final StorageRepository _storageRepository = GetIt.instance.get<StorageRepository>();
   final PaymentsRepository _paymentsRepository = GetIt.instance.get<PaymentsRepository>();

   Future<void> loadAthleteDetails(String parentId) async {
     try {
       emit(state.copyWith(pageStatus: PageStatus.loading));

       log('Getting Parent with id $parentId ...');
       Parent? parent = await _parentsRepository.getParent(parentId);
       log('${parent!.name} ${parent.surname} getted!');

       log('Getting Payments...');
       List<Payment> payments = await _paymentsRepository.getPayments(state.athlete.docId);
       log('Payment successfully getted!');

       log('Checking Documents...');
       String? medLink = await _storageRepository.checkMedFile(state.athlete.docId, state.athlete.teamId);
       String? modIscrLink = await _storageRepository.checkModIscrFile(state.athlete.docId, state.athlete.teamId);
       String? tessFIPLink = await _storageRepository.checkTessFile(state.athlete.docId, state.athlete.teamId);
       Map<String, String> otherFilesMap = await _storageRepository.checkOtherFile(state.athlete.docId, state.athlete.teamId);
       log('Documents checked!');

       emit(state.copyWith(parent: parent, payments: payments, medLink: medLink, modIscrLink: modIscrLink, tessFIPLink: tessFIPLink, otherFilesMap: otherFilesMap));
     } catch (e) {
       log(e.toString());
       emit(state.copyWith(pageStatus: PageStatus.failure));
     } finally {
       emit(state.copyWith(pageStatus: PageStatus.loaded));
     }
   }

   Future<void> loadAthlete(String id) async {
     try {
       emit(state.copyWith(pageStatus: PageStatus.loading));

       log('Getting Athlete with id $id ...');
       Athlete? athlete = await _athletesRepository.getAthlete(id);
       log('Athlete getted!');

       emit(state.copyWith(athlete: athlete));
     } catch (e) {
       log(e.toString());
       emit(state.copyWith(pageStatus: PageStatus.failure));
     }
   }

   Future<void> uploadMedEventHandler(File file, DateTime expire) async {

     log('Uploading Med Doc...');
     emit(state.copyWith(uploadStatus: UploadStatus.uploading));
     final path = 'visiteMediche/${state.athlete.teamId}/${state.athlete.docId}.pdf';
     final metadata = SettableMetadata(
       customMetadata: {
         "expiring-date": expire.toIso8601String(),
       },
     );
     await _storageRepository.uploadFile(path, file, metadata);
     log('Upload Success!');
     log('Path: $path');

     String? medLink = await _storageRepository.checkMedFile(state.athlete.docId, state.athlete.teamId);
     emit(state.copyWith(medLink: medLink, uploadStatus: UploadStatus.success));
     emit(state.copyWith(uploadStatus: UploadStatus.none));
   }

   Future<void> uploadModIscrEventHandler(File file) async {

     log('Uploading ModIscr Doc...');
     emit(state.copyWith(uploadStatus: UploadStatus.uploading));
     final path = 'moduloIscrizioni/${state.athlete.teamId}/${state.athlete.docId}.pdf';
     await _storageRepository.uploadFile(path, file);
     log('Upload Success!');
     log('Path: $path');

     String? modIscrLink = await _storageRepository.checkModIscrFile(state.athlete.docId, state.athlete.teamId);
     emit(state.copyWith(modIscrLink: modIscrLink, uploadStatus: UploadStatus.success));
     emit(state.copyWith(uploadStatus: UploadStatus.none));
   }

   Future<void> uploadTessFIPEventHandler(File file) async {

     log('Uploading TessFIP Doc...');
     emit(state.copyWith(uploadStatus: UploadStatus.uploading));
     final path = 'tessFIP/${state.athlete.teamId}/${state.athlete.docId}.pdf';
     await _storageRepository.uploadFile(path, file);
     log('Upload Success!');
     log('Path: $path');

     String? tessFIPLink = await _storageRepository.checkTessFile(state.athlete.docId, state.athlete.teamId);
     emit(state.copyWith(tessFIPLink: tessFIPLink, uploadStatus: UploadStatus.success));
     emit(state.copyWith(uploadStatus: UploadStatus.none));
   }

   Future<void> uploadGenericEventHandler(File file, String name) async {

     log('Uploading $name ...');
     emit(state.copyWith(uploadStatus: UploadStatus.uploading));
     final path = 'altri/${state.athlete.teamId}/${state.athlete.docId}/$name';
     await _storageRepository.uploadFile(path, file);
     log('Upload Success! \n path: $path');
     Map<String, String> otherFilesMap = await _storageRepository.checkOtherFile(state.athlete.docId, state.athlete.teamId);
     emit(state.copyWith(otherFilesMap: otherFilesMap, uploadStatus: UploadStatus.success));
     emit(state.copyWith(uploadStatus: UploadStatus.none));
   }

   Future<void> deleteDocumentEventHandler(String path) async {
     log('Deleting $path ...');
     await _storageRepository.deleteFile(path);
     log('$path successfully deleted!');

     String? medLink = await _storageRepository.checkMedFile(state.athlete.docId, state.athlete.teamId);
     String? modIscrLink = await _storageRepository.checkModIscrFile(state.athlete.docId, state.athlete.teamId);
     String? tessFIPLink = await _storageRepository.checkTessFile(state.athlete.docId, state.athlete.teamId);
     Map<String, String> otherFilesMap = await _storageRepository.checkOtherFile(state.athlete.docId, state.athlete.teamId);
     emit(state.copyWith(medLink: medLink, modIscrLink: modIscrLink, tessFIPLink: tessFIPLink, otherFilesMap: otherFilesMap));
   }

   Future<void> generateInvoice(Payment payment, Athlete athlete, Parent parent) async {
     MessageUtil.showLoading();
     final PdfService service = PdfService();
     final Uint8List data;
     if(payment.amount == athlete.amount) {
        data = await service.createInvoice(payment, athlete, parent, InvoiceType.saldo);
     }else {
       data = await service.createInvoice(payment, athlete, parent, InvoiceType.acconto);
     }
     MessageUtil.hideLoading();
     await service.savePdfFile("Invoice_${athlete.surname}_${athlete.name}_${DateTime.now().millisecond}", data);
   }

    Future<void> addPayment({required String amount, required DateTime date, required type}) async {
      MessageUtil.showLoading();
      Payment payment = Payment(
          docId: '',
          athlete: state.athlete.docId,
          amount: int.parse(amount),
          date: Timestamp.fromDate(date),
          receiptNum: await _paymentsRepository.getNewInvoiceNum(),
      );
      await _paymentsRepository.addPayment(payment);
      MessageUtil.hideLoading();
    }
}