import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

class PaymentView extends ConsumerStatefulWidget {
  const PaymentView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView> {
  @override
  Widget build(BuildContext context) {
    final works = ref.read(workProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ödeme'),
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
                    return Container(
                      margin: context.padding.onlyBottomLow,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('${payment.model} - ${payment.plate}'
                            .toUpperCase()),
                        subtitle: Text(
                            '${payment.customerName} - ${payment.customerPhone}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${payment.totalAmount} TL'),
                            SizedBox(
                              width: 25.w,
                              height: 3.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: (payment.isPaid ?? false)
                                    ? [
                                        const Text('Ödendi'),
                                        const Icon(Icons.check,
                                            color: Colors.green),
                                      ]
                                    : [
                                        const Text('Ödenmedi'),
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
}
