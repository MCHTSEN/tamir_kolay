import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

class CustomersView extends ConsumerStatefulWidget {
  const CustomersView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomersViewState();
}

class _CustomersViewState extends ConsumerState<CustomersView> {
  @override
  Widget build(BuildContext context) {
    final works = ref.read(workProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteriler'),
      ),
      body: works.isEmpty
          ? const Center(
              child: Text('Henüz müşteri eklenmedi.'),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: works.length,
              itemBuilder: (context, index) {
                final work = works[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(work.customerName ?? 'Isim Girilmedi'),
                      InkWell(
                        onTap: () async {
                          Clipboard.setData(
                              ClipboardData(text: work.customerPhone!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              content: const Center(
                                  child: Text(
                                'Numara kopyalandı!',
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${work.customerPhone}".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.black),
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
                      Gap(1.h),
                      Text(
                        'T.C. No: ${work.tcNo ?? 'Adres Girilmedi'}',
                      ),
                      Gap(1.h),
                    ],
                  ),
                );
              }),
    );
  }
}
