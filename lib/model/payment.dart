import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  Payment({
    required this.docId,
    required this.athlete,
    required this.amount,
    required this.date,
    required this.receiptNum,
  });

  final String docId;
  final String athlete;
  int amount = 0;
  int receiptNum;
  Timestamp date;

  factory Payment.fromSnapshot(DocumentSnapshot snap) => Payment(
    docId: snap.id,
    athlete: snap['athleteId'],
    amount: snap['amount'],
    date: snap['date'],
    receiptNum: snap['invoiceNum'],
  );
}