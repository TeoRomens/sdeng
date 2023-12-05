import 'package:sdeng/model/athlete.dart';

class MedVisit{
  MedVisit(
      {
        required this.athlete,
        required this.expiringDate,
      });

  final Athlete athlete;
  final DateTime expiringDate;
}

