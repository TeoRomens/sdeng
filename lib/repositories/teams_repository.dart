import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/team.dart';

class TeamsRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addTeam(String name) async {
    Map<String, dynamic> data = {
      'name': name,
      'athletes': [],
    };

    try{
      _firebaseFirestore.collection('teams/${Variables.uid}/teams').add(data);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteTeam(String docId) async {
    try{
      FirebaseFirestore.instance
          .collection('teams/${Variables.uid}/teams')
          .doc(docId)
          .delete();

    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Team>> getTeams() async {
    List<Team> teamsList = [];
    try{
      final data = await _firebaseFirestore
          .collection('teams/${Variables.uid}/teams')
          .orderBy('name', descending: false)
          .get();

      teamsList = data.docs.map((e) => Team.fromSnapshot(e)).toList();
      return teamsList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTeam(String teamId, String athleteDoc) async {
    try{
      await _firebaseFirestore.collection('teams/${Variables.uid}/teams')
            .doc(teamId).update({'athletes' : FieldValue.arrayUnion([athleteDoc])});

    } catch (e) {
      throw Exception(e.toString());
    }

  }

  Future<bool> checkName(String name) async {
    try{
      final data = await _firebaseFirestore.collection('teams/${Variables.uid}/teams')
          .where('name', isEqualTo: name)
          .get();
      return data.docs.isEmpty;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeAthleteFromTeam(String teamId, String athleteId) async {
    try{
      FirebaseFirestore.instance
          .collection('teams/${Variables.uid}/teams')
          .doc(teamId)
          .update({'athletes': FieldValue.arrayRemove([athleteId])});

    } catch (e) {
      log(e.toString());
    }
  }
}