import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/parent.dart';

class ParentsRepository{

  final FirebaseFirestore _firebaseFirestore;

  ParentsRepository({FirebaseFirestore? firebaseFirestore}) :
  _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> addParent(Parent parent) async {
    Map<String, dynamic> data = {
      'name': parent.name,
      'surname': parent.surname,
      'phone': parent.phone,
      'email': parent.email,
      'taxId': parent.taxId,
    };

    String parentDocId = '';

    try{
      parentDocId = await _firebaseFirestore.collection('parents/${Variables.uid}/parents').add(data).then((value) => value.id);
    } catch (e){
      log(e.toString());
    }

    return parentDocId;
  }

  Future<void> removeParent(String docId) async {
    try{
      FirebaseFirestore.instance
          .collection('parents/${Variables.uid}/parents')
          .doc(docId)
          .delete();

    } catch (e) {
      log(e.toString());
    }
  }

  Future<Parent?> getParent(String parentId) async {
    try{
      final doc = await _firebaseFirestore.collection('parents/${Variables.uid}/parents')
          .doc(parentId)
          .get();

      return Parent.fromSnapshot(doc);
    } catch (e) {
      log(e.toString());
      return null;
    }

  }

  Future<void> editParent(Parent parent) async {
    final parentRef = _firebaseFirestore.collection('parents/${Variables.uid}/parents').doc(parent.docId);
    await parentRef.update({
      'name': parent.name,
      'phone': parent.phone,
      'email': parent.email,
      'surname': parent.surname,
      'taxId': parent.taxId,
    }).then((value) => log("DocumentSnapshot ${parent.docId} successfully updated!"),
        onError: (e) => log("Error updating document $e"));
  }

}