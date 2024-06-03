import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/vehicle_registration/vehicle_registration_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';
import 'package:uuid/uuid.dart';

// CarFormViewModel sınıfı
mixin VehicleRegistrationViewModel on State<VehicleRegistrationView> {
  final String appBarTitle = 'Araç Kayıt Formu';
  final String brandLabel = 'Marka';
  final String modelLabel = 'Model';
  final String modelYearLabel = 'Model Yılı';
  final String licensePlateLabel = 'Plaka';
  final String tcNoLabel = 'Müşteri Tc Kimlik No';
  final String customerNameLabel = 'Müşteri Adı Soyadı';
  final String customerPhoneLabel = 'Müşteri Telefon';
  final String customerPhoneHint = '05XX XXX XX XX';
  final String issueLabel = 'Yaşanılan Sorun';
  final String mileageLabel = 'Kilometre';
  final String submitButtonLabel = 'Kayıt Aç';

  var uuid = const Uuid();
  final TextEditingController brandController =
      TextEditingController(text: 'Kawasaki');
  final TextEditingController modelController =
      TextEditingController(text: 'Ninja H2R');
  final TextEditingController modelYearController =
      TextEditingController(text: '2022');
  final TextEditingController customerNameController =
      TextEditingController(text: 'Mucahit SEN');
  final TextEditingController customerPhoneController =
      TextEditingController(text: '05050161116');
  final TextEditingController issueController = TextEditingController(
      text:
          'Motor ilk çalışmada hemen mars almiyor. Calistiktan sonra 5-10 dk sonra mars aliyor. Ayrica zincirden ses geliyor.');
  final TextEditingController licensePlateController =
      TextEditingController(text: '16 HR 016');
  final TextEditingController mileageController =
      TextEditingController(text: '1300');
  final TextEditingController tcNoController =
      TextEditingController(text: '28165339568');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    modelYearController.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    issueController.dispose();
    licensePlateController.dispose();
    mileageController.dispose();
    tcNoController.dispose();
    super.dispose();
  }

  Future<void> submitForm(WidgetRef ref) async {
    DateTime now = DateTime.now();
    final randomIdForWork = uuid.v4();
    final userID = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference =
        firestore.collection('vehicle_registrations').doc('works');

    // Set the data for the document
    final json = Work(
      id: randomIdForWork,
      brand: brandController.text,
      model: modelController.text,
      modelYear: modelYearController.text,
      customerName: customerNameController.text,
      customerPhone: customerPhoneController.text,
      issue: issueController.text,
      plate: licensePlateController.text,
      kilometer: mileageController.text,
      tcNo: tcNoController.text,
      createTime: now.toString(),
      endTime: '',
      status: VehicleStatus.waiting.name,
      isPaid: false,
      totalAmount: 0,
    ).toJson();
    ref.read(workProvider.notifier).addWork(Work.fromJson(json));
    inspect(json);

    await documentReference.collection(userID).doc(randomIdForWork).set(json);

    // Navigator.of(context).pop();
  }

  Future<dynamic> showCustomDialog(WidgetRef ref) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Başarılı!'),
          content: const Text('Araç kaydı başarıyla oluşturuldu.'),
          actions: [
            TextButton(
              onPressed: () async {
                await ref.read(workProvider.notifier).getWorks();

                Navigator.of(context).pushNamed('/home');
              },
              child: const Text('Bitir'),
            ),
          ],
        );
      },
    );
  }
}
