import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

class BussinessView extends ConsumerStatefulWidget {
  const BussinessView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BussinessViewState();
}

class _BussinessViewState extends ConsumerState<BussinessView> {
  @override
  Widget build(BuildContext context) {
    final works = ref.read(workProvider);
    final totalEarnedMoney = works
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toString();
    final totalCompletedWorks = works
        .where((element) => element.status == 'done')
        .toList()
        .length
        .toString();
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tamir Kolay',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const Text('İşletme Hesabı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ListTile(
                title: const Text('Musteriler',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.chevron_right)),
              ),
              const Divider(),
              Gap(2.h),
              const Text('Aylık İstatistikler',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Gap(2.h),
              CustomContainer(
                title: "Kazanç",
                value: '$totalEarnedMoney₺',
              ),
              Gap(2.h),
              CustomContainer(
                  title: 'Tamamlanan İş ', value: totalCompletedWorks),
            ],
          ),
        ));
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Gap(5.w),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          Gap(5.w),
        ],
      ),
    );
  }
}
