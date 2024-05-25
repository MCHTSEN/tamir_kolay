import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/bussiness/bussiness_viewmodel.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/extensions/double_extension.dart';

class BussinessView extends ConsumerStatefulWidget {
  const BussinessView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BussinessViewState();
}

class _BussinessViewState extends ConsumerState<BussinessView>
    with BussinessViewModel {
  bool isClickedEarnedMoney = false;
  @override
  Widget build(BuildContext context) {
    final works = ref.read(workProvider);
    initialize(works);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/auth');
              },
            ),
          ],
        ),
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
                onTap: () => Navigator.pushNamed(context, '/customers'),
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
                value: '${totalEarnedMoney.toDouble().toCurrency()}₺',
                onTap: () {
                  setState(() {
                    print('Kazanç tıklandı');
                    isClickedEarnedMoney = !isClickedEarnedMoney;
                  });
                },
              ),
              isClickedEarnedMoney
                  ? const Column(
                      children: [
                        // Text('Gelir: ${totalEarnedMoney.toDouble().toCurrency()}₺'),
                      ],
                    )
                  : const SizedBox.shrink(),
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
    this.onTap,
  });
  final String title;
  final String value;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
