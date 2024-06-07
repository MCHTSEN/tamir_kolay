import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Work>> getAllWorks() async {
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

  Future<void> updateEndTime(
    String workId,
  ) async {
    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(workId)
          .update({'endTime': DateTime.now().toString()});
      print('FirebaseService: updateEndTime triggered.');
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> updateExpenses(
      {required List<Expense> expenses, required String workId}) async {
    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(workId)
          .update({
        'expense': expenses.map((expense) => expense.toJson()).toList()
      });
      print('FirebaseService: updateExpenses triggered.');
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> updateTasks(
      {required List<Task> tasks, required String workId}) async {
    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(workId)
          .update({'task': tasks.map((tasks) => tasks.toJson()).toList()});
      print('FirebaseService: updateExpenses triggered.');
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> updateWork(Work work) async {
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

  Future<void> updateStatus(String workId, VehicleStatus status) async {
    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(workId)
          .update({'status': status.name});
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> addLabourCost(String workId, double amount) async {
    try {
      await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .doc(workId)
          .update({'labourCost': amount});
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<Map<String, double>> compareMonthlyAmounts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Şu anki tarih
    DateTime now = DateTime.now();

    // Bu ayın başı ve bir önceki ayın başı
    String thisMonthStart = DateTime(now.year, now.month, 1).toString();
    String lastMonthStart = DateTime(now.year, now.month - 1, 1).toString();

    // Bu ayın şu anki tarihine kadar olan tarih aralığı
    String thisMonthEnd =
        DateTime(now.year, now.month, now.day, 23, 59, 59).toString();

    // Bir önceki ayın şu anki tarihine kadar olan tarih aralığı
    String lastMonthEnd =
        DateTime(now.year, now.month - 1, now.day, 23, 59, 59).toString();
    double thisMonthTotalAmount = 0;
    double lastMonthTotalAmount = 0;
    double thisMonthWorksCount = 0;
    double lastMonthWorksCount = 0;
    try {
      QuerySnapshot thisMonthSnapshot = await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .where('endTime', isGreaterThanOrEqualTo: thisMonthStart)
          .where('endTime', isLessThanOrEqualTo: thisMonthEnd)
          .get();

      for (var doc in thisMonthSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        thisMonthWorksCount += data['status'] == 'done' ? 1 : 0;
        thisMonthTotalAmount += data['totalAmount'];
      }

      // Geçen ayki işler
      QuerySnapshot lastMonthSnapshot = await firestore
          .collection('vehicle_registrations')
          .doc('works')
          .collection(userId)
          .where('endTime', isGreaterThanOrEqualTo: lastMonthStart)
          .where('endTime', isLessThanOrEqualTo: lastMonthEnd)
          .get();

      for (var doc in lastMonthSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        print('total: ${data['totalAmount']}');
        lastMonthWorksCount += data['status'] == 'done' ? 1 : 0;
        lastMonthTotalAmount += data['totalAmount'];
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    print('thisMonthTotalAmount: $thisMonthTotalAmount');
    print('lastMonthTotalAmount: $lastMonthTotalAmount');
    print('difference: ${thisMonthTotalAmount - lastMonthTotalAmount}');
    final double compareEarnedAmount =
        thisMonthTotalAmount > lastMonthTotalAmount
            ? (thisMonthTotalAmount / lastMonthTotalAmount) * 100
            : ((thisMonthTotalAmount / lastMonthTotalAmount) - 1) * 100;
    print('compare: $compareEarnedAmount');
    final double compareWorksCount = thisMonthWorksCount > lastMonthWorksCount
        ? (thisMonthWorksCount / lastMonthWorksCount) * 100
        : ((thisMonthWorksCount / lastMonthWorksCount) - 1) * 100;
    print('compareWorksCount: $compareWorksCount');
    return {
      'compareEarnedAmount': compareEarnedAmount,
      'compareWorksCount': compareWorksCount
    };
  }
}
