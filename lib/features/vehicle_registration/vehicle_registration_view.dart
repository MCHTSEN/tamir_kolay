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
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
                        decoration: InputDecoration(
                          labelText: brandLabel,
                        ),
                        validator: Validators.brandValidator,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: TextFormField(
                        controller: modelController,
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    labelText: customerNameLabel,
                  ),
                  validator: Validators.customerNameValidator,
                ),
                const Gap(10),
                TextFormField(
                  controller: customerPhoneController,
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    labelText: issueLabel,
                  ),
                  validator: Validators.issueValidator,
                ),
                const Gap(10),
                TextFormField(
                  controller: mileageController,
                  decoration: InputDecoration(
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
                      submitForm.call(ref);
                      showCustomDialog(ref);
                    }
                  },
                  child: Text(submitButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
