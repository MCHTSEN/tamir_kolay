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
  var uuid = const Uuid();
  final TextEditingController brandController =
      TextEditingController(text: 'Audi');
  final TextEditingController modelController =
      TextEditingController(text: 'Model');
  final TextEditingController modelYearController =
      TextEditingController(text: '2022');
  final TextEditingController customerNameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController customerPhoneController =
      TextEditingController(text: '12345678901');
  final TextEditingController issueController =
      TextEditingController(text: 'Some issue');
  final TextEditingController licensePlateController =
      TextEditingController(text: 'ABC123');
  final TextEditingController mileageController =
      TextEditingController(text: '10000');
  final TextEditingController tcNoController =
      TextEditingController(text: '12345678901');
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

  Future<void> submitForm() async {
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                await ref.read(workProvider.notifier).getWorks();
                
              },
              child: const Text('Bitir'),
            ),
          ],
        );
      },
    );
  }
}
