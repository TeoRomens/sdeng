import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/athlete.dart';

/// A class that interacts with the Firestore database to manage athlete data.
class AthletesRepository{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// Retrieves a list of athletes belonging to a specific team.
  ///
  /// Returns a list of [Athlete] objects associated with the provided [teamId].
  /// If any errors occur during the data retrieval, they are logged.
  Future<List<Athlete>> getAthletesFromTeam(String teamId) async {
    List<Athlete> athleteList = [];
    try{
       var data = await _firebaseFirestore
          .collection('teams/${Variables.uid}/teams')
          .doc(teamId)
          .get();
       log('Team ${data.id} getted');

       List<dynamic> athletesId = data.get('athletes');
       for (var data in athletesId) {
         DocumentSnapshot athleteDoc;
         athleteDoc = await _firebaseFirestore
             .collection('athletes/${Variables.uid}/athletes')
             .doc(data.toString())
             .get();
         log('Athlete ${athleteDoc.id} getted');
         athleteList.add(Athlete.fromSnapshot(athleteDoc));
       }
    } catch (e) {
      log(e.toString());
    }
    athleteList.sort((a, b) => a.number!.compareTo(b.number!));
    return athleteList;
  }

  /// Adds a new athlete to the database.
  ///
  /// Takes an [athlete] object and adds its data to the Firestore database.
  /// Returns the ID of the newly added athlete document.
  Future<String> addAthlete(Athlete athlete) async {
    Map<String, dynamic> data = {
      'name': athlete.name,
      'surname': athlete.surname,
      'birth': athlete.birth,
      'bornCity': athlete.bornCity,
      'city': athlete.city,
      'address': athlete.address,
      'phone': athlete.phone,
      'email': athlete.email,
      'taxId': athlete.taxId,
      'number': athlete.number,
      'teamId': athlete.teamId,
      'parentId': athlete.parentId,
      'amount': athlete.amount,
    };

    return await _firebaseFirestore
        .collection('athletes/${Variables.uid}/athletes')
        .add(data)
      .then((value) => value.id);
  }


  Future<int> getEarnings(List<Athlete> athletes) async {
    int sum = 0;
    for(final athlete in athletes) {
      sum += athlete.amount;
    }
    return sum;
  }

  /// A method to calculate the remaining cash to be collected from a specific team.
  ///
  /// Given a [teamId], this method calculates the total amount of cash
  /// remaining to be collected from athletes in the specified team.
  /// It does this by querying the Firestore database for athlete and payment documents
  /// and checking the 'primaRataPaid' and 'secondaRataPaid' fields in each payment document.
  ///
  /// Returns the total remaining cash as an integer value.
  Future<int> getRemainingCash(List<Athlete> athleteList) async {
    // Initialize a variable to store the total remaining cash.
    int result = 0;

    for (var athlete in athleteList) {
      final paymentList = await FirebaseFirestore.instance
          .collection('payments/${Variables.uid}/payments')
          .where('athleteId', isEqualTo: athlete.docId)
          .get();

      for(var doc in paymentList.docs) {
        result += doc.get('amount') as int;
      }
    }
    // Return the total remaining cash to be collected from the team.
    return result;
  }

  /// A method to delete an athlete's data from the database.
  ///
  /// Given an [docId], which is the unique identifier of the athlete document in the Firestore database,
  /// this method deletes the athlete's data from the database.
  Future<void> deleteAthlete(String docId) async {
    // Delete the athlete document from the Firestore database.
    FirebaseFirestore.instance
        .collection('athletes/${Variables.uid}/athletes')
        .doc(docId)
        .delete();
  }

  /// A method to retrieve an athlete's information from the database by their unique [docId].
  ///
  /// Given an athlete's unique identifier ([docId]), this method queries the Firestore database to
  /// retrieve the athlete's data. It assumes that the athlete document with the provided [docId] exists.
  /// The document is converted into an [Athlete] object using the `Athlete.fromSnapshot` method and returned.
  ///
  /// Returns an [Athlete] object.
  Future<Athlete?> getAthlete(String docId) async {
    // Query the Firestore database to retrieve the athlete's document by [docId].
    final doc = await _firebaseFirestore.collection('athletes/${Variables.uid}/athletes')
        .doc(docId)
        .get();

    // Convert the retrieved document into an Athlete object and return it.
    return Athlete.fromSnapshot(doc);
  }

  /// A method to retrieve the total number of athletes in the database.
  ///
  /// This method queries the Firestore database to count the total number of athlete documents.
  /// It returns the count as an integer value.
  ///
  /// Returns the total number of athletes as an integer.
  Future<int> getNumAthletes() async {
    // Query the Firestore database to count the total number of athlete documents.
    return await _firebaseFirestore
        .collection('athletes/${Variables.uid}/athletes')
        .count()
        .get().then((value) => value.count);
  }

  /// A method to edit an athlete's information in the database.
  ///
  /// Given an [athlete] object, this method updates the athlete's information in the Firestore database.
  /// It specifically updates fields such as 'address', 'birth', 'bornCity', 'city', 'name', 'number',
  /// 'parentId', 'paymentId', 'phone', 'email', 'surname', 'taxId', and 'team'.
  ///
  /// If the update is successful, it logs a success message.
  Future<void> editAthlete(Athlete athlete) async {
    // Create a reference to the athlete's document using the [athlete.docId].
    final athleteRef = _firebaseFirestore
        .collection('athletes/${Variables.uid}/athletes')
        .doc(athlete.docId);

    // Update the athlete's information in the Firestore database.
    await athleteRef.update({
      'address': athlete.address,
      'birth': athlete.birth,
      'bornCity': athlete.bornCity,
      'city': athlete.city,
      'name': athlete.name,
      'number': athlete.number,
      'parentId': athlete.parentId,
      'phone': athlete.phone,
      'email': athlete.email,
      'surname': athlete.surname,
      'taxId': athlete.taxId,
      'team': athlete.teamId,
      'amount': athlete.amount,
    }).then((value) => log("DocumentSnapshot ${athlete.docId} successfully updated!"));
  }

  /// A method to search for athletes in the database by name.
  ///
  /// Given a search [string], this method queries the Firestore database to find athletes
  /// whose 'name' matches the provided string. It retrieves the athlete documents that match
  /// the search criteria and converts them into [Athlete] objects.
  ///
  /// Returns a list of [Athlete] objects that match the search criteria.
  Future<List<Athlete>> searchAthlete(String string) async {
    // Initialize a list to store the found athletes.
    List<Athlete> athleteList = [];

    // Query the Firestore database to find athletes by matching 'name' with the provided [string].
    var data = await _firebaseFirestore
        .collection('athletes/${Variables.uid}/athletes')
        .where('name', isGreaterThanOrEqualTo: string)
        .get();

    // Iterate through the retrieved athlete documents.
    for (var doc in data.docs) {
      // Log that an athlete has been retrieved.
      log('Athlete ${doc.id} retrieved');

      // Convert the document into an Athlete object and add it to the list.
      athleteList.add(Athlete.fromSnapshot(doc));
    }

    // Return the list of athletes that match the search criteria.
    return athleteList;
  }
}