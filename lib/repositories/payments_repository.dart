import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/payment.dart';

class PaymentsRepository{

  final FirebaseFirestore _firebaseFirestore;

  PaymentsRepository({FirebaseFirestore? firebaseFirestore}) :
  _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> addPayment(Payment payment) async {
    try{
      Map<String, dynamic> data = {
        'amount': payment.amount,
        'athleteId': payment.athlete,
        'date': payment.date,
        'invoiceNum': payment.receiptNum,
      };

      final paymentDocId = await _firebaseFirestore.collection('payments/${Variables.uid}/payments').add(data).then((value) => value.id);
      return paymentDocId;

    } catch (e){
      log(e.toString());
    }
    return '';
  }

  Future<void> removePayments(String athleteId)  async {
    try{
      final data = await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .where('athleteId', isEqualTo: athleteId)
          .get();

      for(var doc in data.docs) {
        _firebaseFirestore
            .collection('payments/${Variables.uid}/payments')
            .doc(doc.id)
            .delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removePayment(String paymentId) async {
    try{
      await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .doc(paymentId)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Payment>> getPayments(String athleteId) async {
    try{
      final data = await _firebaseFirestore.collection('payments/${Variables.uid}/payments')
          .where('athleteId', isEqualTo: athleteId)
          .get();

      List<Payment> payments = [];
      for (DocumentSnapshot snapshot in data.docs) {
        payments.add(Payment.fromSnapshot(snapshot));
      }
      return payments;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Payment>> getAllPayments() async {
    List<Payment> payments = [];
    try{
      final data = await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .get();

      payments = data.docs.map((e) => Payment.fromSnapshot(e)).toList();

    } catch (e){
      log(e.toString());
    }
    return payments;
  }

  Future<int> getNumPrimaRataPaid() async {
    try{
      return await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .where('rataUnica', isEqualTo: false)
          .where('primaRataPaid', isEqualTo: true)
          .count()
          .get().then((value) => value.count);

    } catch (e){
      log(e.toString());
    }
    return 0;
  }

  Future<int> getNumSecRataPaid() async {
    try{
      return await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .where('rataUnica', isEqualTo: false)
          .where('secondaRataPaid', isEqualTo: true)
          .count()
          .get().then((value) => value.count);

    } catch (e){
      log(e.toString());
    }
    return 0;
  }

  Future<int> getNumRataUnPaid() async {
    try{
      return await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .where('rataUnica', isEqualTo: true)
          .where('primaRataPaid', isEqualTo: true)
          .count()
          .get().then((value) => value.count);

    } catch (e){
      log(e.toString());
    }
    return 0;
  }

  Future<int> getAlreadyCashed() async {
    int cashed = 0;
    try{
      final data =  await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .get();
      for(var element in data.docs){
        if(element.get('primaRataPaid')){
          cashed += element.get('primaRata') as int;
        }
        if(element.get('secondaRataPaid')){
          cashed += element.get('secondaRata') as int;
        }
      }
    } catch (e){
      log(e.toString());
    }
    return cashed;
  }

  Future<int> getCashLeft() async {
    int cash = 0;
    try{
      final data =  await _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .get();
      for(var element in data.docs){
        if(!element.get('primaRataPaid')){
          cash += element.get('primaRata') as int;
        }
        if(!element.get('secondaRataPaid')){
          cash += element.get('secondaRata') as int;
        }
      }
    } catch (e){
      log(e.toString());
    }
    return cash;
  }

  Future<void> editPayment(Payment payment) async {
    final paymentRef = _firebaseFirestore.collection('payments/${Variables.uid}/payments').doc(payment.docId);
    await paymentRef.update({
      'amount': payment.amount,
      'athlete': payment.athlete,
      'date': payment.date,
    }).then((value) => log("DocumentSnapshot ${payment.docId} successfully updated!"),
        onError: (e) => log("Error updating document\n\t$e"));
  }

  Future<int> getNewInvoiceNum() async {
    try{
      final doc = await _firebaseFirestore
          .collection('users')
          .doc(Variables.uid)
          .get();

      await _firebaseFirestore.collection("users").doc(Variables.uid).update({"invoice": doc.get('invoice') + 1});
      return doc.get('invoice') as int;
    } catch (e){
      log(e.toString());
    }
    return -1;
  }
}