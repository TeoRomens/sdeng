import 'package:cloud_firestore/cloud_firestore.dart';

class Parent{
  Parent(
  {
    required this.docId,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.taxId,
  });

  final String docId;
  String name;
  String surname;
  String email;
  String phone;
  String taxId;

  factory Parent.fromSnapshot(DocumentSnapshot snap) => Parent(
    docId: snap.id,
    name: snap['name'],
    surname: snap['surname'],
    email: snap['email'],
    phone: snap['phone'],
    taxId: snap['taxId'],
  );

}