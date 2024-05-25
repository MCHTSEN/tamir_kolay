import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

class PaymentView extends ConsumerStatefulWidget {
  const PaymentView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView> {
  @override
  Widget build(BuildContext context) {
    final works = ref.watch(workProvider);
    final generalTextTheme = context.general.textTheme.bodyLarge!.copyWith(
        fontSize: 16.8.sp, color: Theme.of(context).colorScheme.secondary);
    final totalAmount = works.fold<double>(
        0, (previousValue, element) => previousValue + element.totalAmount!);

    final totalPaidAmount = works.fold<double>(
        0,
        (previousValue, element) =>
            previousValue + (element.isPaid! ? element.totalAmount! : 0));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ödeme'),
        ),
        bottomSheet: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                child: Text('Alınan Ödeme: \n $totalPaidAmount₺',
                    textAlign: TextAlign.center,
                    style: generalTextTheme.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              )),
              const VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                    child: Text(
                        'Bekleyen Ödeme: \n ${totalAmount - totalPaidAmount}₺',
                        textAlign: TextAlign.center,
                        style: generalTextTheme.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: context.padding.normal,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    final payment = works[index];
                    return payment.expense == null
                        ? const SizedBox()
                        : Container(
                            margin: context.padding.onlyBottomLow,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () => _showBottomSheet(context, payment),
                              title: Text(
                                  '${payment.model} - ${payment.plate}'
                                      .toUpperCase(),
                                  style: generalTextTheme.copyWith(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${payment.customerName} - ${payment.customerPhone}'),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${payment.totalAmount} ₺',
                                    style: generalTextTheme.copyWith(
                                        fontSize: 16.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 27.w,
                                    height: 3.h,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: (payment.isPaid ?? false)
                                          ? [
                                              Text(
                                                'Ödendi',
                                                style:
                                                    generalTextTheme.copyWith(
                                                        fontSize: 15.sp,
                                                        color: Colors.black),
                                              ),
                                              const Icon(Icons.check,
                                                  color: Colors.green),
                                            ]
                                          : [
                                              Text(
                                                'Ödenmedi',
                                                style:
                                                    generalTextTheme.copyWith(
                                                        fontSize: 15.sp,
                                                        color: Colors.black),
                                              ),
                                              const Icon(Icons.close,
                                                  color: Colors.red),
                                            ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Row _nameAndPhone(
      Work work, BuildContext context, TextStyle generalTextTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('${work.customerName}'),
        InkWell(
          onTap: () async {
            Clipboard.setData(ClipboardData(text: work.customerPhone!));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                content: Center(
                    child: Text(
                  'Numara kopyalandı!',
                  style: generalTextTheme.copyWith(color: Colors.white),
                )),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Text(
                  "${work.customerPhone}".toUpperCase(),
                  style: generalTextTheme.copyWith(fontSize: 15.sp),
                ),
                Gap(1.w),
                const Icon(
                  Icons.call,
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Work currentWork) {
    final generalTextTheme = context.general.textTheme.bodyLarge!.copyWith(
        fontSize: 16.8.sp, color: Theme.of(context).colorScheme.secondary);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 35.h + (currentWork.expense?.length ?? 0) * 3.h,
                  width: 100.w,
                  child: Column(
                    children: [
                      const Text(
                        'Ödeme Detayları',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Divider(),
                      Gap(2.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentWork.expense!.length,
                        itemBuilder: (context, index) {
                          final expense = currentWork.expense![index];
                          return Text(
                            '${expense.amount}₺ - ${expense.description}'
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      Text(
                        'Toplam Ödeme: ${currentWork.totalAmount}₺',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      currentWork.isPaid!
                          ? const Text('Ödendi',
                              style: TextStyle(color: Colors.green))
                          : const Text('Ödenmedi',
                              style: TextStyle(color: Colors.red)),
                      Gap(2.h),
                      _nameAndPhone(currentWork, context, generalTextTheme),
                      Gap(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${currentWork.model}/${currentWork.brand}'
                              .toUpperCase()),
                          Text('${currentWork.plate}'.toUpperCase()),
                        ],
                      ),
                      Gap(2.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser!;
                          FirebaseFirestore.instance
                              .collection('vehicle_registrations')
                              .doc('works')
                              .collection(user.uid)
                              .doc(currentWork.id)
                              .update({
                            'isPaid':
                                (currentWork.isPaid ?? true) ? false : true
                          });

                          ref.read(workProvider.notifier).updateWork(
                                currentWork.copyWith(
                                    isPaid: !currentWork.isPaid!),
                              );
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          (currentWork.isPaid ?? true)
                              ? Icons.close
                              : Icons.check,
                          color: Colors.white,
                        ),
                        label: Text(
                          (currentWork.isPaid ?? true)
                              ? 'Ödenmedi olarak işaretle'
                              : 'Ödendi olarak işaretle',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(100.w, 5.h),
                            backgroundColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.black, size: 25),
              ),
            ),
          ],
        );
      },
    );
  }
}
