import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Base failure class for the news repository failures.
abstract class DocumentsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const DocumentsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching documents fails.
class GetDocumentsFailure extends DocumentsFailure {
  /// {@macro get_documents_failure}
  const GetDocumentsFailure(super.error);
}

/// Thrown when adding a document fails.
class AddDocumentFailure extends DocumentsFailure {
  /// {@macro add_document_failure}
  const AddDocumentFailure(super.error);
}

/// A repository that manages documents.
class DocumentsRepository {
  /// {@macro documents_repository}
  const DocumentsRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  /// * [limit] - The number of results to return.
  Future<List<Document>> getDocumentsFromAthleteId({
    required String athleteId,
    int? limit,
  }) async {
    try {
      return await _apiClient.getDocumentsFromFolder(
        path: 'documents/athletes/$athleteId',
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetDocumentsFailure(error), stackTrace);
    }
  }

  /// Add a new document
  ///
  /// Supported parameters:
  /// [athleteId] -
  /// [file] -
  Future<String> uploadAthleteDocument({
    required File file,
    required String athleteId,
    String? filename,
  }) async {
    try {
      final fileName = filename ?? file.path.split('/').last;
      return await _apiClient.uploadFile(
        path: 'documents/athletes/$athleteId/$fileName',
        file: file,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddDocumentFailure(error), stackTrace);
    }
  }

  /// Download a existing document
  ///
  /// Supported parameters:
  /// [path] - Url of the document
  Future<Uint8List> downloadFile({required String path}) async {
    try {
      return await _apiClient.downloadFile(
        path: path,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddDocumentFailure(error), stackTrace);
    }
  }

  ///
  /// Supported parameters:
  /// [path] - Url of the document
  Future<void> deleteFile({required String path}) async {
    try {
      await _apiClient.deleteFile(
        path: path,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddDocumentFailure(error), stackTrace);
    }
  }

  Future<File> generateRichiestaVisitaMedica({
    required Athlete athlete,
    required SdengUser user,
  }) async {
    final boldStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    const svgCheckBox = '''
    <svg width="10" height="10">
      <rect width="10" height="10" x="0" y="0" style="stroke-width:1;stroke:black;fill:rgb(255,255,255)" />
    </svg>
  ''';
    final checkBox = pw.SvgImage(svg: svgCheckBox);


    final pdf = pw.Document()
      ..addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text("RICHIESTA DI VISITA MEDICO-SPORTIVA PER L'IDONEITA' ALLA PRATICA AGONISTICA",
                    style: boldStyle,
                    textAlign: pw.TextAlign.center
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text('(DM del 24/04/2013 - Decreto Balduzzi e del Decreto del Fare, convertito in legge 98, art. 42.bis, pubblicato nella GU il 20 agosto 2013)',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.Text('La società: ${user.societyName}',),
                pw.Text('con sede in: ${user.societyAddress}',),
                pw.Text('affiliata alla Federazione Sportiva Nazionale con matricola n. ${user.societyPiva}',),
                pw.SizedBox(height: 12),
                pw.Center(
                  child: pw.Text('chiede che il proprio atleta',
                      style: boldStyle,
                      textAlign: pw.TextAlign.center
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Nome e Cognome: ${athlete.fullName}',),
                pw.Text('Abitante a: ${athlete.fullAddress}',),
                pw.Text('Cod Fiscale: ${athlete.taxCode}',),
                pw.SizedBox(height: 12),
                pw.Center(
                  child: pw.Text("Si sottoponga ad una visita medico-sportiva per l'idoneità alla pratica agonistica dello sport:",),
                ),
                pw.Center(
                  child: pw.Text('Pallacanestro', style: boldStyle),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Sbarrare una delle seguenti opzioni:'),
                pw.Row(
                  children: [
                    checkBox,
                    pw.Text('  Prima Affiliazione'),
                  ],
                ),
                pw.Row(
                  children: [
                    checkBox,
                    pw.Text("  Rinnovo (allegare ultimo certificato in originale in possesso dell'atleta)"),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('Firma del presidente',
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.SizedBox(height: 120),
                pw.Text("N.B. La mancata o l'errata compilazione di uno dei dati richiesti e/o la mancata presentazione dell'ultimo certificato rende nulla la richiesta.'\nPer prima affiliazione si intende la prima visita in assoluto dell'atleta richiesta per qualsiasi sport, tutte le successive anche per sport diversi sono da considerarsi rinnovi.'\nLa richiesta deve essere compilata a macchina o con carattere stampatello, timbrata e firmata in originale. La richiesta non può essere presentata prima di 30 gg. dalla scadenza del certificato precedente. II presidente non può compilare più richieste di visita per lo stesso atleta nel corso degli 11 mesi successivi.",
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontStyle: pw.FontStyle.italic,
                    ),
                ),
              ],
            ); // Center
          },
        ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/Richiesta-Visita-Medica.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

}
