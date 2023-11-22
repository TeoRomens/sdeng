
import 'package:cloud_firestore/cloud_firestore.dart';

class Team{

  const Team({
    required this.docId,
    required this.name,
    required this.athletesId,
  });
  final String docId;
  final String name;
  final List<String> athletesId;

  factory Team.fromSnapshot(DocumentSnapshot snap) => Team(
    docId: snap.id,
    name: snap['name'] ?? "",
    athletesId: List<String>.from(snap['athletes']),
  );
  
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'athletes': athletesId,
  };
}