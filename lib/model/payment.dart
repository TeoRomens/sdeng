import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';

class Payment {
  Payment({
    this.docId,
    required this.athlete,
    required this.amount,
    required this.rataUnica,
    required this.primaRata,
    required this.secondaRata,
    this.date1,
    this.date2,
    this.primaRataPaid = false,
    this.secondaRataPaid = false,
  });

  final String? docId;
  final String athlete;
  int amount = Variables.quotaUnder;
  bool primaRataPaid;
  bool secondaRataPaid;
  int primaRata;
  int secondaRata;
  bool rataUnica;
  Timestamp? date1;
  Timestamp? date2;

  factory Payment.fromSnapshot(DocumentSnapshot snap) => Payment(
    docId: snap.id,
    athlete: snap['athlete'],
    amount: snap['amount'],
    primaRata: snap['primaRata'],
    secondaRata: snap['secondaRata'],
    primaRataPaid: snap['primaRataPaid'],
    secondaRataPaid: snap['secondaRataPaid'],
    rataUnica: snap['rataUnica'],
    date1: snap['date1'],
    date2: snap['date2'],
  );
}