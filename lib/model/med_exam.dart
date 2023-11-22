import 'package:cloud_firestore/cloud_firestore.dart';

class MedExam{
  MedExam(
      {
        required this.athleteId,
        required this.expiringDate,
      });

  final String athleteId;
  final Timestamp expiringDate;
}