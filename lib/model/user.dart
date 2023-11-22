import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
  });

  final String id;
  final String name;
  final String surname;
  final String email;

  factory User.fromSnap(DocumentSnapshot snap) => User(
    id: snap.id,
    name: snap['name'] ?? "",
    surname: snap['surname'] ?? "",
    email: snap['email'] ?? "",
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'surname': surname,
    'email': email,
  };

  @override
  List<Object?> get props => [id, name, surname, email];
}