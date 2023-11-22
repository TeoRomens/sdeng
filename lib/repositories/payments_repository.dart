import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/payment.dart';

class PaymentsRepository{

  final FirebaseFirestore _firebaseFirestore;

  PaymentsRepository({FirebaseFirestore? firebaseFirestore}) :
  _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<String> addPayment(Payment payment) async {
    Map<String, dynamic> data = {
      'amount': payment.amount,
      'athlete': payment.athlete,
      'primaRataPaid': payment.primaRataPaid,
      'secondaRataPaid': payment.secondaRataPaid,
      'primaRata': payment.primaRata,
      'secondaRata': payment.secondaRata,
      'rataUnica': payment.rataUnica,
      'date1': payment.date1 != null ? payment.date1! : null,
      'date2': payment.date2 != null ? payment.date2! : null,
    };

    String paymentDocId = '';

    try{
      paymentDocId = await _firebaseFirestore.collection('payments/${Variables.uid}/payments').add(data).then((value) => value.id);
    } catch (e){
      log(e.toString());
    }

    return paymentDocId;
  }



  Future<void> removePayment(String paymentId)  async {
    try{
      _firebaseFirestore
          .collection('payments/${Variables.uid}/payments')
          .doc(paymentId)
          .delete();

    } catch (e) {
      log(e.toString());
    }
  }

  Future<Payment?> getPayment(String paymentId) async {
    try{
      final doc = await _firebaseFirestore.collection('payments/${Variables.uid}/payments')
          .doc(paymentId)
          .get();

      return Payment.fromSnapshot(doc);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<Payment>> getExpiredPayments() async {
    List<Payment> expired = [];
    if(DateTime.now().isAfter(Variables.secondPaymentDate)){
      log('Checking seconda rata');
      try{
        final data = await _firebaseFirestore
            .collection('payments/${Variables.uid}/payments')
            .where('rataUnica', isEqualTo: false)
            .where('secondaRataPaid', isEqualTo: false,)
            .get();

        expired = data.docs.map((e) => Payment.fromSnapshot(e)).toList();

      } catch (e){
        log(e.toString());
      }
    }
    else if(DateTime.now().isAfter(Variables.firstPaymentDate)){
      log('Checking prima rata');
      try{
        final data = await _firebaseFirestore
            .collection('payments/${Variables.uid}/payments')
            .where('primaRataPaid', isEqualTo: false)
            .get();
        
        expired = data.docs.map((e) => Payment.fromSnapshot(e)).toList();
      } catch (e){
        log(e.toString());
      }
    }
    return expired;
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
      'date1': payment.date1,
      'date2': payment.date2,
      'primaRata': payment.primaRata,
      'primaRataPaid': payment.primaRataPaid,
      'secondaRata': payment.secondaRata,
      'secondaRataPaid': payment.secondaRataPaid,
      'rataUnica': payment.rataUnica
    }).then((value) => log("DocumentSnapshot ${payment.docId} successfully updated!"),
        onError: (e) => log("Error updating document\n\t$e"));
  }

  Future<int> getInvoiceNum(String docId) async {
    try{
      final paymentDoc = await _firebaseFirestore.collection('payments/${Variables.uid}/payments').doc(docId).get();
      return paymentDoc.get('invoiceNum') as int;
    } catch (e){
      final doc = await _firebaseFirestore.collection(Variables.uid).doc('variables').get();
      final num = doc.get('invoice') as int;
      await _firebaseFirestore.collection("payments").doc(docId).update({"invoiceNum": num});
      await _firebaseFirestore.collection("shared").doc('invoice').update({"last": num+1});
      return num;
    }
  }

}