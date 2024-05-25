import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tamir_kolay/models/job_model.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  Future<List<Work>> getAllWorks() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Work> works = [];

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        works.add(Work.fromJson(data));
      }
    } catch (e) {
      print("Hata oluştu: $e");
      // Hata durumunda boş bir liste döndür
      return works;
    }
    return works;
  }

  Future<void> updateWork(Work work) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(work.id)
          .update(work.toJson());
      print('FirebaseService: updateWork triggered.');
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }
}
