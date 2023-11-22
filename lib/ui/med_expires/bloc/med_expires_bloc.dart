import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';

part 'med_expires_state.dart';

class MedExpiresBloc extends Cubit<MedExpiresState> {
  MedExpiresBloc() : super(MedExpiresState());

  final AthletesRepository athletesRepository = GetIt.instance<AthletesRepository>();
  final StorageRepository storageRepository = GetIt.instance<StorageRepository>();

  Future<void> load(Team team) async {
    try {
      emit(state.copyWith(status: Status.loading, team: team));

      log('Getting athletes...');
      List<Athlete> athletesList = await athletesRepository.getAthletesFromTeam(team.docId);
      log('Athletes getted');
      log('Getting expires...');
      List<DateTime> expires = await storageRepository.getExpiresFromTeam(team.docId);
      log('Expires getted');

      emit(state.copyWith(athletesList: athletesList, expiresDateList: expires, status: Status.loaded));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<void> uploadMedEventHandler({
      required PlatformFile platformFile,
      required String teamId,
      required String athleteId,
      required DateTime expire
  }) async {

    log('Uploading Med Doc...');
    emit(state.copyWith(uploadStatus: UploadStatus.uploading));
    final file = File(platformFile.path!);
    final path = 'visiteMediche/$teamId/$athleteId.pdf';
    final metadata = SettableMetadata(
      customMetadata: {
        "expiring-date": expire.toIso8601String(),
      },
    );
    await storageRepository.uploadFile(path, file, metadata);
    log('Upload Success!');
    log('Path: $path');

    emit(state.copyWith(uploadStatus: UploadStatus.success));
    emit(state.copyWith(uploadStatus: UploadStatus.none));
  }

}