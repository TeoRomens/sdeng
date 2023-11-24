import 'package:get_it/get_it.dart';
import 'package:open_document/my_files/init.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/payments_repository.dart';

enum InvoiceType{
  saldo,
  acconto
}

class PdfService {
  Future<Uint8List> createInvoice(Payment payment, Athlete athlete, Parent parent, InvoiceType type) async {
    final pdf = pw.Document();
    final image = (await rootBundle.load( "assets/logos/SDENG_logo.jpg" )).buffer.asUint8List();
    final invoiceNumber = GetIt.I.get<PaymentsRepository>().getNewInvoiceNum();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Image(pw.MemoryImage(image), width: 200, height: 150, fit: pw.BoxFit.contain),
            pw.SizedBox(height: 50),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('${parent.surname.toUpperCase()} ${parent.name.toUpperCase()}'),
                    pw.Text('Customer Address'),
                    pw.Text('Cod Fisc: ${parent.taxId.toUpperCase()}'),
                  ]
                ),
                pw.Column(
                    children: [
                      pw.Text('Pallacanestro Cerro Maggiore'),
                      pw.Text('Via Varese 14'),
                      pw.Text('20023 Cerro Maggiore (MI)'),
                      pw.Text('P.Iva 07099690963'),
                    ]
                )
              ]
            ),
            pw.SizedBox(height: 20),
            pw.Text("Ricevuta N°$invoiceNumber del ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
            pw.SizedBox(height: 30),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                          child: pw.Text('Codice',
                              textAlign: pw.TextAlign.left)),
                      pw.Expanded(
                          child: pw.Text('Name',
                              textAlign: pw.TextAlign.left)),
                      pw.Expanded(
                          child: pw.Text('Type',
                              textAlign: pw.TextAlign.right)),
                      pw.Expanded(
                          child: pw.Text('Total',
                              textAlign: pw.TextAlign.right)),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    children: [
                      pw.Expanded(
                          child: pw.Text('ICB',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                          )),
                      pw.Expanded(
                          child: pw.Text('Iscrizione Corso Basket Stagione Sportiva ${DateTime.now().year}',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                          )),
                      pw.Expanded(
                          child: pw.Text(type.name.toUpperCase(),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                          )),
                      pw.Expanded(
                          child: pw.Text(payment.amount.toStringAsFixed(2),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                          )),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Nome dell\'atleta che esercita l\'attività sportiva dilettantistica'),
                          pw.Text('${athlete.surname} ${athlete.name} - ${athlete.taxId}'),
                          pw.Text('${athlete.birth.toDate().day}/${athlete.birth.toDate().month}/${athlete.birth.toDate().year} - ${athlete.bornCity}'),
                          pw.Text('Customer Address'),
                        ]
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Operazione Fuori Campo Iva ai sensi dell\'art. 4 comma 4 del D:P:R 633/72',
                      style: pw.TextStyle(
                          fontStyle: pw.FontStyle.italic
                      )
                  ),
                  pw.SizedBox(height: 10),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Pagamento Bonifico Bancario\nIBAN: IT94P0306909606100000146005\nData Bonifico: ${payment.date.toDate().day}-${payment.date.toDate().month}-${payment.date.toDate().year}'),
                  ),
                ],
              ),
            ),
            pw.Text("Codice FIP 052115  052115@spes.fip.it\nwww.pallacanestrocerromaggiore.it mail: ssdbasketcerromaggiore@gmail.com", textAlign: pw.TextAlign.center),
          ]
        );
      }
    ));
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List bytelist) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(bytelist);
    await OpenDocument.openDocument(filePath: filePath);
    output.delete(recursive: true);
    await output.create();
  }
}

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String vat;

  CustomRow(this.itemName, this.itemPrice, this.vat);
}