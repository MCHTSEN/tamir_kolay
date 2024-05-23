import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tamir_kolay/features/vehicle_registration/vehicle_registration_viewmodel.dart';
import 'package:tamir_kolay/utils/validators/validators.dart';

class VehicleRegistrationView extends ConsumerStatefulWidget {
  const VehicleRegistrationView({super.key});

  @override
  _VehicleRegistrationViewState createState() =>
      _VehicleRegistrationViewState();
}

class _VehicleRegistrationViewState
    extends ConsumerState<VehicleRegistrationView>
    with VehicleRegistrationViewModel {
  @override
  Widget build(BuildContext context) {
    const String appBarTitle = 'Araç Kayıt Formu';
    const String brandLabel = 'Marka';
    const String modelLabel = 'Model';
    const String modelYearLabel = 'Model Yılı';
    const String licensePlateLabel = 'Plaka';
    const String tcNoLabel = 'Müşteri Tc Kimlik No';
    const String customerNameLabel = 'Müşteri Adı Soyadı';
    const String customerPhoneLabel = 'Müşteri Telefon';
    const String customerPhoneHint = '05XX XXX XX XX';
    const String issueLabel = 'Yaşanılan Sorun';
    const String mileageLabel = 'Kilometre';
    const String submitButtonLabel = 'Kayıt Aç';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: brandController,
                        decoration: const InputDecoration(
                          labelText: brandLabel,
                        ),
                        validator: Validators.brandValidator,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: TextFormField(
                        controller: modelController,
                        decoration: const InputDecoration(
                          labelText: modelLabel,
                        ),
                        validator: Validators.modelValidator,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: modelYearController,
                        decoration: const InputDecoration(
                          labelText: modelYearLabel,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: Validators.modelYearValidator,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: TextFormField(
                        controller: licensePlateController,
                        decoration: const InputDecoration(
                          labelText: licensePlateLabel,
                        ),
                        validator: Validators.licensePlateValidator,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                TextFormField(
                  controller: tcNoController,
                  decoration: const InputDecoration(
                    labelText: tcNoLabel,
                  ),
                  validator: Validators.tcNoValidator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const Gap(10),
                TextFormField(
                  controller: customerNameController,
                  decoration: const InputDecoration(
                    labelText: customerNameLabel,
                  ),
                  validator: Validators.customerNameValidator,
                ),
                const Gap(10),
                TextFormField(
                  controller: customerPhoneController,
                  decoration: const InputDecoration(
                    labelText: customerPhoneLabel,
                    hintText: customerPhoneHint,
                  ),
                  validator: Validators.phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const Gap(10),
                TextFormField(
                  controller: issueController,
                  decoration: const InputDecoration(
                    labelText: issueLabel,
                  ),
                  validator: Validators.issueValidator,
                ),
                const Gap(10),
                TextFormField(
                  controller: mileageController,
                  decoration: const InputDecoration(
                    labelText: mileageLabel,
                  ),
                  validator: Validators.mileageValidator,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    /// TODO change this to if (viewModel.formKey.currentState!.validate()) {
                    if (formKey.currentState!.validate()) {
                      submitForm.call();
                      showCustomDialog();
                    }
                  },
                  child: const Text(submitButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
