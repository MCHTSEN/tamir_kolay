import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/payment/payment_viewmodel.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';
import 'package:tamir_kolay/utils/extensions/double_extension.dart';

class PaymentView extends ConsumerStatefulWidget {
  const PaymentView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView>
    with PaymentViewModel {
  @override
  Widget build(BuildContext context) {
    final works = ref.watch(workProvider);
    final generalTextTheme = context.general.textTheme.bodyLarge!.copyWith(
        fontSize: 16.8.sp, color: Theme.of(context).colorScheme.secondary);
    final totalAmount = calculateTotalAmount(works);
    final totalPaidAmount = calculateTotalPaidAmount(works);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ödeme'),
        ),
        bottomSheet:
            customBottomAppBar(totalPaidAmount, generalTextTheme, totalAmount),
        body: Padding(
          padding: context.padding.normal,
          child: Column(
            children: [
              Expanded(
                child: _paymentCards(works, generalTextTheme),
              ),
            ],
          ),
        ));
  }

  ListView _paymentCards(List<Work> works, TextStyle generalTextTheme) {
    return ListView.builder(
      itemCount: works.length,
      itemBuilder: (context, index) {
        final payment = works[index];
        print('${payment.status}: ');
        return !(payment.status == VehicleStatus.done.name)
            ? const SizedBox.shrink()
            : Container(
                margin: context.padding.onlyBottomLow,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () => showCustomBottomSheet(context, payment, ref),
                  title: modelAndPlate(payment, generalTextTheme),
                  subtitle: name(payment),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${payment.totalAmount!.toDouble().toCurrency()} ₺',
                        style: generalTextTheme.copyWith(
                            fontSize: 16.sp, color: Colors.black),
                      ),
                      SizedBox(
                        width: 27.w,
                        height: 3.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (payment.isPaid ?? false)
                              ? [
                                  Text(
                                    'Ödendi',
                                    style: generalTextTheme.copyWith(
                                        fontSize: 15.sp, color: Colors.black),
                                  ),
                                  const Icon(Icons.check, color: Colors.green),
                                ]
                              : [
                                  Text(
                                    'Ödenmedi',
                                    style: generalTextTheme.copyWith(
                                        fontSize: 15.sp, color: Colors.black),
                                  ),
                                  const Icon(Icons.close, color: Colors.red),
                                ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
