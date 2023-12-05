import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/model/user.dart';

class StaffMember extends User {
  const StaffMember({
    required super.name,
    required super.surname,
    required super.email,
    required super.id,
    required this.societyName,
    required this.societyEmail,
    required this.societyTaxId,
    required this.societyPIva,
    required this.societyFipCode,
    required this.societyAddress,
    required this.societyCity,
    required this.societyCap,
    required this.closingPayDate1,
    required this.closingPayDate2,
    required this.totalAmountUnder,
    required this.totalAmountMB,
  });

  final String societyName;
  final String societyEmail;
  final String societyTaxId;
  final String societyPIva;
  final String societyFipCode;
  final String societyAddress;
  final String societyCity;
  final String societyCap;

  final DateTime? closingPayDate1;
  final DateTime? closingPayDate2;
  final int? totalAmountUnder;
  final int? totalAmountMB;

  factory StaffMember.fromSnap(DocumentSnapshot snap) => StaffMember(
    id: snap.id,
    name: snap['name'] ?? "",
    surname: snap['surname'] ?? "",
    email: snap['email'] ?? "",
    societyName: snap['societyName'],
    societyEmail: snap['societyEmail'],
    societyAddress: snap['societyAddress'],
    societyCity: snap['societyCity'],
    societyCap: snap['societyCap'],
    societyPIva: snap['societyPIva'],
    societyTaxId: snap['societyTaxId'],
    societyFipCode: snap['societyFipCode'],
    closingPayDate1: snap['firstPaymentDate'],
    closingPayDate2: snap['secondPaymentDate'],
    totalAmountMB: snap['quotaMB'],
    totalAmountUnder: snap['quotaUnder']
  );

}