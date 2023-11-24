import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class of an Athlete
class Athlete{
  Athlete(
  {
    required this.docId,
    required this.name,
    required this.surname,
    required this.bornCity,
    required this.birth,
    required this.taxId,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.teamId,
    required this.number,
    required this.amount,
    required this.parentId,
  });

  final String docId;
  String name;
  String surname;
  String bornCity;
  String taxId;
  Timestamp birth;
  String address;
  String city;
  String phone;
  String email;
  final String teamId;
  int? number;
  int amount;
  final String parentId;

  factory Athlete.fromSnapshot(DocumentSnapshot snap) => Athlete(
    docId: snap.id,
    name: snap['name'],
    surname: snap['surname'],
    bornCity: snap['bornCity'],
    birth: snap['birth'],
    taxId: snap['taxId'],
    address: snap['address'],
    city: snap['city'],
    phone: snap['phone'],
    email: snap['email'],
    teamId: snap['teamId'],
    number: snap['number'],
    amount: snap['amount'],
    parentId: snap['parentId'],
  );

}